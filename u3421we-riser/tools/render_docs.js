// Turn the generated SVG/HTML in docs/ into the PNGs and the template PDF.
// Usage: node tools/render_docs.js      Needs: playwright (with Chromium).
const { chromium } = require('playwright');
const path = require('path');
const docs = path.join(__dirname, '..', 'docs');
const url = f => 'file://' + path.join(docs, f);
(async () => {
  const b = await chromium.launch();
  for (const [svg, w, h] of [['outline-u3421we', 1100, 815], ['seat-section', 1160, 640]]) {
    const p = await b.newPage({ viewport: { width: w, height: h }, deviceScaleFactor: 2 });
    await p.goto(url(svg + '.svg'));
    await p.screenshot({ path: path.join(docs, svg + '.png') });
  }
  const p = await b.newPage();
  await p.goto(url('_template.html'));
  await p.pdf({ path: path.join(docs, 'outline-u3421we-1to1-A4.pdf'), format: 'A4', printBackground: true,
                margin: { top: 0, bottom: 0, left: 0, right: 0 }, preferCSSPageSize: true });
  await b.close();
})();
