from pathlib import Path
import re

path = Path('.archify/erd-respaldo4-20261015-130000/modelo-eer-respaldo4.html')
html = path.read_text(encoding='utf-8')

style = r'''
<style id="full-width-draggable-tables">
  html, body { width: 100%; min-width: 0; margin: 0; }
  body { padding-left: clamp(10px, 1.5vw, 24px) !important; padding-right: clamp(10px, 1.5vw, 24px) !important; }
  .container { width: 100% !important; max-width: none !important; box-sizing: border-box; }
  .diagram-container { width: 100% !important; min-width: 0; box-sizing: border-box; }
  .diagram-container > svg { display: block; width: 100% !important; max-width: none !important; height: auto !important; }
  #table-layout-controls { display:flex; gap:8px; align-items:center; margin-left:auto; }
  #table-layout-controls button { border:1px solid #475569; border-radius:9px; padding:8px 11px; background:#101828; color:#f5f7ff !important; font:600 13px/1.2 system-ui,sans-serif !important; white-space:nowrap; cursor:pointer; }
  #table-layout-controls button[aria-pressed="true"] { border-color:#42c8d6; color:#73e1ea; box-shadow:0 0 0 2px #42c8d633; }
  .demo-totals-card { grid-column:1 / -1; }
  .demo-totals-card ul { display:grid; grid-template-columns:repeat(4,minmax(0,1fr)); gap:6px 18px; }
  @media (max-width:900px) { .demo-totals-card ul { grid-template-columns:repeat(2,minmax(0,1fr)); } }
  @media (max-width:560px) { .demo-totals-card ul { grid-template-columns:1fr; } }
  svg[data-table-drag="on"] [data-node-id] { cursor:grab !important; }
  svg[data-table-drag="on"] [data-node-id]:active { cursor:grabbing !important; }
  @media (max-width:700px) { #table-layout-controls button { padding:7px 8px; font-size:12px; } }
</style>
'''
controls = r'''
<div id="table-layout-controls" role="group" aria-label="Posiciones de las tablas">
  <button id="toggle-table-drag" type="button" aria-pressed="false">Mover tablas: OFF</button>
  <button id="reset-table-layout" type="button">Restablecer</button>
</div>
<script>
(function () {
  'use strict';
  var svg = document.querySelector('.diagram-container > svg[data-erd-ui]');
  var toolbar = document.querySelector('.toolbar');
  var toggle = document.getElementById('toggle-table-drag');
  var reset = document.getElementById('reset-table-layout');
  if (!svg || !toolbar || !toggle || !reset) return;
  toolbar.appendChild(document.getElementById('table-layout-controls'));
  var storageKey = 'archify-table-layout-db-test-7b-v1';
  var nodes = Array.from(svg.querySelectorAll('[data-node-id]')).filter(function (n) { return n.querySelector('.c-mask'); });
  var edges = Array.from(svg.querySelectorAll('path[data-edge-from][data-edge-to]'));
  var offsets = Object.create(null);
  var dragging = false;
  var current = null;
  var start = null;
  var original = null;
  var moved = false;

  function rect(node) { return node.querySelector('.c-mask'); }
  function applyNode(node) {
    var p = offsets[node.getAttribute('data-node-id')] || {x:0,y:0};
    if (p.x || p.y) node.setAttribute('transform', 'translate(' + p.x + ' ' + p.y + ')');
    else node.removeAttribute('transform');
  }
  function anchor(node, side) {
    var r = rect(node), id = node.getAttribute('data-node-id'), p = offsets[id] || {x:0,y:0};
    var x = Number(r.getAttribute('x')) + p.x, y = Number(r.getAttribute('y')) + p.y;
    var w = Number(r.getAttribute('width')), h = Number(r.getAttribute('height'));
    if (side === 'left') return {x:x,y:y+h/2};
    if (side === 'right') return {x:x+w,y:y+h/2};
    if (side === 'top') return {x:x+w/2,y:y};
    return {x:x+w/2,y:y+h};
  }
  function reroute() {
    edges.forEach(function (edge) {
      var from = nodes.find(function (n) { return n.getAttribute('data-node-id') === edge.getAttribute('data-edge-from'); });
      var to = nodes.find(function (n) { return n.getAttribute('data-node-id') === edge.getAttribute('data-edge-to'); });
      if (!from || !to || from === to) return;
      var a = rect(from), b = rect(to), pa = offsets[from.getAttribute('data-node-id')] || {x:0,y:0}, pb = offsets[to.getAttribute('data-node-id')] || {x:0,y:0};
      var ax = Number(a.getAttribute('x')) + pa.x + Number(a.getAttribute('width'))/2;
      var ay = Number(a.getAttribute('y')) + pa.y + Number(a.getAttribute('height'))/2;
      var bx = Number(b.getAttribute('x')) + pb.x + Number(b.getAttribute('width'))/2;
      var by = Number(b.getAttribute('y')) + pb.y + Number(b.getAttribute('height'))/2;
      var sideA, sideB;
      if (Math.abs(bx-ax) >= Math.abs(by-ay)) { sideA = bx >= ax ? 'right' : 'left'; sideB = bx >= ax ? 'left' : 'right'; }
      else { sideA = by >= ay ? 'bottom' : 'top'; sideB = by >= ay ? 'top' : 'bottom'; }
      var p1 = anchor(from, sideA), p2 = anchor(to, sideB), d;
      if (sideA === 'left' || sideA === 'right') {
        var mx = (p1.x+p2.x)/2;
        d = 'M '+p1.x+' '+p1.y+' L '+mx+' '+p1.y+' L '+mx+' '+p2.y+' L '+p2.x+' '+p2.y;
      } else {
        var my = (p1.y+p2.y)/2;
        d = 'M '+p1.x+' '+p1.y+' L '+p1.x+' '+my+' L '+p2.x+' '+my+' L '+p2.x+' '+p2.y;
      }
      edge.setAttribute('d', d);
      edge.setAttribute('data-composition-points', p1.x+','+p1.y+';'+p2.x+','+p2.y);
      var key = edge.getAttribute('data-edge-id');
      var labelGroups = svg.querySelectorAll('g[data-edge-id]');
      Array.prototype.forEach.call(labelGroups, function (g) {
        if (g.getAttribute('data-edge-id') !== key) return;
        var text = g.querySelector('text');
        if (text) { text.setAttribute('x', (p1.x+p2.x)/2); text.setAttribute('y', (p1.y+p2.y)/2-8); }
      });
    });
  }
  function point(event) {
    var p = svg.createSVGPoint(); p.x = event.clientX; p.y = event.clientY;
    return p.matrixTransform(svg.getScreenCTM().inverse());
  }
  function save() { try { localStorage.setItem(storageKey, JSON.stringify(offsets)); } catch (_) {} }
  try {
    var stored = JSON.parse(localStorage.getItem(storageKey) || '{}');
    if (stored && typeof stored === 'object') offsets = stored;
  } catch (_) { offsets = Object.create(null); }
  nodes.forEach(applyNode);
  reroute();
  toggle.addEventListener('click', function () {
    dragging = !dragging;
    svg.setAttribute('data-table-drag', dragging ? 'on' : 'off');
    toggle.setAttribute('aria-pressed', String(dragging));
    toggle.textContent = 'Mover tablas: ' + (dragging ? 'ON' : 'OFF');
  });
  reset.addEventListener('click', function () {
    offsets = Object.create(null);
    nodes.forEach(applyNode); reroute();
    try { localStorage.removeItem(storageKey); } catch (_) {}
  });
  nodes.forEach(function (node) {
    node.addEventListener('pointerdown', function (event) {
      if (!dragging || event.button !== 0) return;
      event.preventDefault(); event.stopPropagation();
      current = node; moved = false; start = point(event);
      var id = node.getAttribute('data-node-id');
      original = offsets[id] || {x:0,y:0};
      node.setPointerCapture(event.pointerId);
    }, true);
    node.addEventListener('pointermove', function (event) {
      if (!dragging || current !== node || !start) return;
      event.stopPropagation();
      var now = point(event), id = node.getAttribute('data-node-id');
      var next = {x:original.x+now.x-start.x,y:original.y+now.y-start.y};
      if (Math.abs(now.x-start.x)+Math.abs(now.y-start.y)>2) moved = true;
      offsets[id] = next; applyNode(node); reroute();
    }, true);
    function finish(event) {
      if (current !== node) return;
      if (moved) save();
      current = null; start = null; original = null;
    }
    node.addEventListener('pointerup', finish, true);
    node.addEventListener('pointercancel', finish, true);
  });
})();
</script>
'''

if 'id="full-width-draggable-tables"' in html:
    html = re.sub(r'<style id="full-width-draggable-tables">.*?</style>', style.strip(), html, count=1, flags=re.S)
else:
    html = html.replace('</head>', style + '\n</head>', 1)
if 'id="table-layout-controls"' in html:
    html = re.sub(r'<div id="table-layout-controls".*?</script>', controls.strip(), html, count=1, flags=re.S)
else:
    html = html.replace('</body>', controls + '\n</body>', 1)
path.write_text(html, encoding='utf-8')
