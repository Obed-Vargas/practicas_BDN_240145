from pathlib import Path
import re

path = Path('.archify/erd-respaldo4-20261015-130000/modelo-eer-respaldo4.html')
html = path.read_text(encoding='utf-8')
counts = {
    'tb_carts': ('7', 'demo'),
    'tb_logs': ('5,025', 'respaldo'),
    'tb_products': ('5,007', 'respaldo'),
    'tb_users': ('7', 'respaldo'),
    'tbc_categories': ('100', 'demo'),
    'tbd_products_categories': ('7,510', 'demo'),
    'tbd_products_users_providers': ('35', 'demo'),
    'tbd_users_wishlist_products': ('420', 'demo'),
}

# Keep the per-entity count visible in each table header.
html = re.sub(r'\s*<text data-table-count="[^"]*"[^>]*/>', '', html)
for table, (total, origin) in counts.items():
    marker = f'data-node-id="{table}"'
    node_at = html.find(marker)
    if node_at < 0:
        raise RuntimeError(f'Missing entity in diagram: {table}')
    node_start = html.rfind('<g ', 0, node_at)
    title = re.search(r'<text data-node-label="" x="([\d.]+)" y="([\d.]+)"[^>]*>[^<]*</text>', html[node_at:])
    mask = re.search(r'<rect x="([\d.]+)" y="([\d.]+)" width="([\d.]+)" height="[\d.]+" rx="[\d.]+" class="c-mask"', html[node_at:])
    if not title or not mask:
        raise RuntimeError(f'Could not locate header geometry: {table}')
    if len(table) > 18:
        old = title.group(0)
        smaller = old.replace('font-size="13"', 'font-size="9.5"', 1)
        html = html[:node_at] + html[node_at:].replace(old, smaller, 1)
        title = re.search(r'<text data-node-label="" x="([\d.]+)" y="([\d.]+)"[^>]*>[^<]*</text>', html[node_at:])
    width = float(mask.group(3))
    y = float(title.group(2))
    x = float(mask.group(1)) + width - 8
    color = '#a5f3fc' if origin == 'respaldo' else '#fbbf24'
    badge = f'<text data-table-count="{table}" x="{x:g}" y="{y:g}" text-anchor="end" fill="{color}" font-size="7.5" font-weight="700">{total} {"real" if origin == "respaldo" else "demo"}</text>'
    insert_at = node_at + title.end()
    html = html[:insert_at] + '\n          ' + badge + html[insert_at:]

card = '''
      <div class="card demo-totals-card" data-demo-count-summary="true">
        <div class="card-header"><div class="card-dot amber"></div><h3>Totales por tabla</h3></div>
        <ul>
          <li>tb_carts: 7 <strong>(inventado para demo)</strong></li>
          <li>tb_logs: 5,025 <strong>(contado en INSERT)</strong></li>
          <li>tb_products: 5,007 <strong>(contado en INSERT)</strong></li>
          <li>tb_users: 7 <strong>(contado en INSERT)</strong></li>
          <li>tbc_categories: 100 <strong>(inventado para demo)</strong></li>
          <li>tbd_products_categories: 7,510 <strong>(inventado para demo)</strong></li>
          <li>tbd_products_users_providers: 35 <strong>(inventado para demo)</strong></li>
          <li>tbd_users_wishlist_products: 420 <strong>(inventado para demo)</strong></li>
        </ul>
        <p>“Demo” identifica cifras inventadas; las cifras “contado en INSERT” proceden del respaldo. Los datos de demostración no se suman al total real del archivo.</p>
      </div>
'''
html = re.sub(r'\s*<div class="card demo-totals-card".*?</div>\s*', '\n', html, count=1, flags=re.S)
cards = '<div class="cards">'
if cards not in html:
    raise RuntimeError('Missing cards container')
html = html.replace(cards, cards + card, 1)
path.write_text(html, encoding='utf-8')
