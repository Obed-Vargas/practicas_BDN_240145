import json, re
from datetime import datetime, timezone
from pathlib import Path

src = Path('Practicas03/backups/respaldo4.sql')
out = Path('.archify/erd-respaldo4-20261015-130000')
out.mkdir(parents=True, exist_ok=True)
sql = src.read_text(encoding='utf-8')
lines = sql.splitlines()

def split_top(s):
    parts=[]; start=0; depth=0; quote=None; i=0
    while i < len(s):
        c=s[i]
        if quote:
            if c == quote:
                if i+1 < len(s) and s[i+1] == quote: i += 1
                elif not escaped(s, i): quote=None
        elif c in "'\"`": quote=c
        elif c=='(': depth+=1
        elif c==')': depth-=1
        elif c==',' and depth==0: parts.append(s[start:i].strip()); start=i+1
        i+=1
    parts.append(s[start:].strip())
    return parts

def escaped(s, i):
    n=0; i-=1
    while i>=0 and s[i]=='\\': n+=1; i-=1
    return n%2==1

tables=[]
for m in re.finditer(r'CREATE TABLE\s+`([^`]+)`\s*\(', sql, re.I):
    name=m.group(1); depth=1; i=m.end(); quote=None
    while i<len(sql) and depth:
        c=sql[i]
        if quote:
            if c==quote:
                if i+1<len(sql) and sql[i+1]==quote: i+=1
                elif not escaped(sql,i): quote=None
        elif c in "'\"`": quote=c
        elif c=='(': depth+=1
        elif c==')': depth-=1
        i+=1
    body=sql[m.end():i-1]
    startline=sql.count('\n',0,m.start())+1
    endline=sql.count('\n',0,i)+1
    cols=[]; pk=[]; uniques=[]; indexes=[]; fks=[]
    for item in split_top(body):
        s=item.strip()
        if s.upper().startswith('PRIMARY KEY'):
            pk=re.findall(r'`([^`]+)`',s[s.upper().find('('):]); continue
        if s.upper().startswith('UNIQUE KEY') or s.upper().startswith('UNIQUE INDEX'):
            q=re.match(r'UNIQUE\s+(?:KEY|INDEX)\s+`([^`]+)`\s*\(([^)]*)\)',s,re.I)
            if q: uniques.append((q.group(1),re.findall(r'`([^`]+)`',q.group(2))))
            continue
        if s.upper().startswith(('KEY ','INDEX ','FULLTEXT KEY','SPATIAL KEY')):
            q=re.search(r'(?:KEY|INDEX)\s+`([^`]+)`\s*\(([^)]*)\)',s,re.I)
            if q: indexes.append((q.group(1),re.findall(r'`([^`]+)`',q.group(2))))
            continue
        if s.upper().startswith('CONSTRAINT'):
            q=re.search(r'CONSTRAINT\s+`([^`]+)`\s+FOREIGN KEY\s*\(([^)]*)\)\s+REFERENCES\s+`([^`]+)`\s*\(([^)]*)\)',s,re.I)
            if q: fks.append({'name':q.group(1),'columns':re.findall(r'`([^`]+)`',q.group(2)),'target':q.group(3),'targetCols':re.findall(r'`([^`]+)`',q.group(4))})
            continue
        q=re.match(r'`([^`]+)`\s+(.+)',s,re.S)
        if not q: continue
        cn=q.group(1); rest=q.group(2).strip()
        type_m=re.match(r'([a-zA-Z]+(?:\s+precision)?(?:\s*\([^)]*\))?(?:\s+unsigned)?(?:\s+zerofill)?)',rest,re.I)
        typ=type_m.group(1).strip() if type_m else rest.split()[0]
        default_m=re.search(r'\bDEFAULT\s+((?:\([^)]*\))|(?:b\'[^\']*\')|(?:_binary\s+\'[^\']*\')|(?:\'[^\']*\')|[^\s,]+)',rest,re.I)
        cols.append({'name':cn,'type':typ,'nullable':not bool(re.search(r'\bNOT NULL\b',rest,re.I)),'default':default_m.group(1) if default_m else None,'auto':bool(re.search(r'\bAUTO_INCREMENT\b',rest,re.I))})
    insert_counts=[]
    for im in re.finditer(r'INSERT INTO\s+`'+re.escape(name)+r'`\s+(?:\([^;]*?\)\s*)?VALUES\s*',sql,re.I):
        # Count only top-level tuples in the INSERT VALUES list; strings and escaped bytes are opaque.
        j=im.end(); depth=0; quote=None; rows=0; in_tuple=False
        while j<len(sql):
            c=sql[j]
            if quote:
                if c==quote:
                    if j+1<len(sql) and sql[j+1]==quote: j+=1
                    elif j==0 or sql[j-1]!='\\': quote=None
            elif c in "'\"`": quote=c
            elif c=='(':
                if depth==0: rows+=1; in_tuple=True
                depth+=1
            elif c==')':
                depth-=1
            elif c==';' and depth==0: break
            j+=1
        insert_counts.append(rows)
    tables.append({'name':name,'columns':cols,'pk':pk,'uniques':uniques,'indexes':indexes,'fks':fks,'count':sum(insert_counts),'start':startline,'end':endline,'ddl':sql[m.start():i]})

db=re.search(r'CREATE DATABASE\s+(?:IF NOT EXISTS\s+)?`([^`]+)`',sql,re.I).group(1)
entities=[]; relationships=[]
ids={t['name']:re.sub(r'[^A-Za-z0-9_-]','_',t['name']) for t in tables}
grid={'tb_users':(0,0),'tb_products':(0,1),'tbc_categories':(0,2),'tbd_products_users_providers':(0,3),'tb_carts':(1,0),'tbd_products_categories':(1,1),'tbd_users_wishlist_products':(1,2),'tb_logs':(1,3)}
for n,t in enumerate(tables):
    attrs=[]
    for c in t['columns']:
        roles=[]
        if c['name'] in t['pk']: roles.append('pk')
        for fk in t['fks']:
            if c['name'] in fk['columns']: roles.append('fk')
        if any(c['name'] in uq for _,uq in t['uniques']): roles.append('uk')
        a={'name':c['name'],'type':c['type']}
        if roles: a['key']=roles[0] if len(roles)==1 else roles
        fk=next((x for x in t['fks'] if c['name'] in x['columns']),None)
        if fk and len(fk['columns'])==1 and len(fk['targetCols'])==1: a['references']=fk['target']+'.'+fk['targetCols'][0]
        attrs.append(a)
    row,col=grid[t['name']]
    entity={'id':ids[t['name']],'label':t['name'],'sublabel':f"{len(t['columns'])} cols · {t['count']:,} filas del respaldo",'row':row,'col':col,'attributes':attrs}
    if t['name']=='tb_logs': entity['width']=420
    if t['name']=='tbd_products_users_providers': entity['width']=430
    entities.append(entity)
for t in tables:
    for fk in t['fks']:
        target=next((x for x in tables if x['name']==fk['target']),None)
        if not target: continue
        if t['name']==target['name']: continue
        unique=any(tuple(cols)==tuple(fk['columns']) for _,cols in t['uniques']) or (len(fk['columns'])==1 and fk['columns'][0] in t['pk'])
        relationships.append({'id':fk['name'],'from':ids[t['name']],'to':ids[target['name']], 'label':fk['name'],'fromCardinality':'one' if unique else 'many','toCardinality':'one','fromOptional':any(c['name'] in fk['columns'] and c['nullable'] for c in t['columns']),'identifying':any(c in t['pk'] for c in fk['columns'])})

fk_notes=[f"{t['name']}.{', '.join(fk['columns'])} → {fk['target']}.{', '.join(fk['targetCols'])} ({fk['name']})" for t in tables for fk in t['fks']]
fk_count=sum(len(t['fks']) for t in tables)
col_count=sum(len(t['columns']) for t in tables)
row_count=sum(t['count'] for t in tables)
other_objects={kind:sorted(set(re.findall(pattern,sql,re.I))) for kind,pattern in {'views':r'\bVIEW\s+`([^`]+)`','procedures':r'\bPROCEDURE\s+`([^`]+)`','functions':r'\bFUNCTION\s+`([^`]+)`','triggers':r'\bTRIGGER\s+`([^`]+)`','sequences':r'\bSEQUENCE\s+`([^`]+)`'}.items()}
view_columns={}
for vm in re.finditer(r'\bCREATE\s+VIEW\s+`([^`]+)`\s+AS\s+SELECT\s+(.*?)\*/',sql,re.I|re.S):
    view_columns[vm.group(1)]=re.findall(r'\bAS\s+`([^`]+)`',vm.group(2),re.I)
metadata={'source':str(src).replace('\\','/'),'dialect':'MySQL 8.0.36','database':db,'analyzedAt':datetime.now(timezone.utc).isoformat(),'counts':{'tables':len(tables),'columns':col_count,'primaryKeys':sum(bool(t['pk']) for t in tables),'foreignKeys':fk_count,'confirmedRelationships':fk_count,'insertRowsInBackup':row_count,'rowCountSource':'calculated_from_backup_inserts','liveDatabaseConnection':False},'objects':other_objects,'viewColumns':view_columns,'tables':[{k:t[k] for k in ('name','columns','pk','uniques','indexes','fks','count','ddl')} for t in tables]}
(out/'schema-metadata.json').write_text(json.dumps(metadata,ensure_ascii=False,indent=2),encoding='utf-8')
candidate={'schema_version':1,'diagram_type':'erd','meta':{'title':f'Modelo EER · {db}','subtitle':'Respaldo MySQL 8 · conteos de filas INSERT del archivo, sin conexión en vivo','locale':'es','output':'.archify/erd-respaldo4-20261015-130000/modelo-eer-respaldo4.html','quality_profile':'standard'},'layout':{'mode':'grid','origin':[35,35],'entityW':250,'gapX':80,'gapY':70},'entities':entities,'relationships':relationships,'cards':[{'dot':'amber','title':'Resumen verificado','items':[f'{len(tables)} tablas · {col_count} columnas · {fk_count} claves foráneas declaradas.',f'{row_count:,} filas INSERT contabilizadas en el archivo; suma comparable solo como conteo del respaldo, no en vivo.','No se ejecutó el SQL.']},{'dot':'amber','title':'Lectura de conteos','items':['Cada cifra cuenta tuplas del bloque INSERT INTO del respaldo.','Tablas sin INSERT: cero filas insertadas en el respaldo. El dump no brinda conteos de una base activa.']},{'dot':'cyan','title':'Claves foráneas declaradas','items':fk_notes},{'dot':'emerald','title':'Vistas y rutinas detectadas','items':[f"Vistas ({len(other_objects['views'])}): {', '.join(other_objects['views'])}.",f"Procedimientos ({len(other_objects['procedures'])}): {', '.join(other_objects['procedures']) or 'ninguno'}."]},{'dot':'violet','title':'Alcance del modelo','items':[f'{len(tables)} tablas físicas detectadas; las vistas quedan listadas por separado. La autorreferencia de categorías está detallada en las claves foráneas.','No se ejecutó ninguna instrucción SQL.']} ]}
(out/'candidate.json').write_text(json.dumps(candidate,ensure_ascii=False,indent=2),encoding='utf-8')
print(json.dumps({'db':db,'tables':[{'name':t['name'],'columns':len(t['columns']),'rows_in_insert':t['count'],'pk':t['pk'],'fks':t['fks'],'lines':[t['start'],t['end']]} for t in tables],'relationships':len(relationships)},ensure_ascii=False,indent=2))
