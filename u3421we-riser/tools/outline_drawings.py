"""Draw the U3421WE base plate outline: dimensioned SVG and 1:1 A4 template.

Usage: python outline_drawings.py [--overlay SCREENSHOT.png]

Writes docs/outline-u3421we.svg and docs/_template.html. Turn those into
the PNG and the two-page PDF with:  node tools/render_docs.js
With --overlay it also draws the outline over Dell's screenshot and writes
docs/_outline-overlay.png (not committed, since the screenshot is Dell's).

The numbers at the top must match the "Dell plate outline" parameters in
the .scad files. Needs: numpy, shapely, and pillow for --overlay.
"""
import numpy as np, math, sys, os
from shapely.geometry import Polygon, box
DOCS=os.path.join(os.path.dirname(os.path.abspath(__file__)),'..','docs')
OVERLAY=sys.argv[sys.argv.index('--overlay')+1] if '--overlay' in sys.argv else None
A=360.56; B=247.0; DEPTH=235.75; RR=640.0; RF=490.0; CR_R=7.0; CR_F=3.5
hA=A/2; hB=B/2
ycr=math.sqrt(RR**2-hA**2)            # rear arc centre y (rear corners at y=0, +y toward front)
sag_r=RR-ycr; yF=DEPTH-sag_r          # front corner chord y
ycf=yF+math.sqrt(RF**2-hB**2); sag_f=RF-math.sqrt(RF**2-hB**2)
ang=math.degrees(math.atan((hA-hB)/yF))
print('rear sag %.2f  corner-chord depth %.2f  front sag %.2f  centre depth %.2f  side angle %.2f'%(sag_r,yF,sag_f,DEPTH-sag_f,ang))
N=200
tr=math.asin(hA/RR); tf=math.asin(hB/RF)
pts=[(RR*math.sin(t), ycr-RR*math.cos(t)) for t in np.linspace(-tr,tr,N)]
pts+=[(RF*math.sin(t), ycf-RF*math.cos(t)) for t in np.linspace(tf,-tf,N)]
sharp=Polygon(pts)
def rnd(p,r): return p.buffer(-r,resolution=32).buffer(r,resolution=32)
mid=yF/2
out=rnd(sharp,CR_R).intersection(box(-300,-100,300,mid)).union(rnd(sharp,CR_F).intersection(box(-300,mid,300,400)))
xy=np.array(out.exterior.coords)
bx=out.bounds; WID=bx[2]-bx[0]; DEP=bx[3]-bx[1]; hW=WID/2; yB=bx[3]
Bm=2*max(x for x,y in xy if y>yF-CR_F-1.5); hBm=Bm/2
print('bbox %.2f x %.2f  front width %.1f'%(WID,DEP,Bm))
print('area cm2 %.1f  bbox'%(out.area/100), [round(v,2) for v in out.bounds])
if OVERLAY:
    from PIL import Image, ImageDraw
    im=Image.open(OVERLAY).convert('RGB'); K=4
    x0,y0,x1,y1=255,145,617,390
    c=im.crop((x0,y0,x1,y1)).resize(((x1-x0)*K,(y1-y0)*K),Image.LANCZOS)
    s=1/1.1915; ox,oy=435.9,189.75
    d=ImageDraw.Draw(c)
    P=[((ox+x*s-x0+0.0)*K,(oy+y*s-y0+0.0)*K) for x,y in xy]
    d.line(P+[P[0]],fill=(230,30,30),width=3)
    c.save(os.path.join(DOCS,'_outline-overlay.png'))
def path(xy,sc=1,dx=0,dy=0): return "M"+" L".join(f"{x*sc+dx:.2f},{y*sc+dy:.2f}" for x,y in xy)+"Z"
# ---------- dimensioned drawing
S=2.0; W=1100; H=815; OX=W/2; OY=150+sag_r*S
X=lambda x:OX+x*S; Y=lambda y:OY+y*S
def hdim(y,xa,xb,lab,ty=-8):
    return f'<line x1="{X(xa)}" y1="{y}" x2="{X(xb)}" y2="{y}" class="d" marker-start="url(#a)" marker-end="url(#a)"/><text x="{(X(xa)+X(xb))/2}" y="{y+ty}" class="dt">{lab}</text>'
def vdim(x,ya,yb,lab,side=1):
    return f'<line x1="{x}" y1="{Y(ya)}" x2="{x}" y2="{Y(yb)}" class="d" marker-start="url(#a)" marker-end="url(#a)"/><text x="{x+8*side}" y="{(Y(ya)+Y(yb))/2+5}" class="dv" text-anchor="{"start" if side>0 else "end"}">{lab}</text>'
ext=lambda x,ya,yb:f'<line x1="{X(x)}" y1="{ya}" x2="{X(x)}" y2="{yb}" class="e"/>'
exh=lambda y,xa,xb:f'<line x1="{xa}" y1="{Y(y)}" x2="{xb}" y2="{Y(y)}" class="e"/>'
o=f'''<svg xmlns="http://www.w3.org/2000/svg" width="{W}" height="{H}" viewBox="0 0 {W} {H}" font-family="Helvetica,Arial,sans-serif">
<defs><marker id="a" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="7" markerHeight="7" orient="auto-start-reverse"><path d="M0,0 L10,5 L0,10 z" fill="#444"/></marker></defs>
<style>.plate{{fill:#dfe3e8;stroke:#1f2933;stroke-width:2.5}}.d{{stroke:#444;stroke-width:1.2}}.e{{stroke:#999;stroke-width:1}}
.dt{{font-size:15px;text-anchor:middle;fill:#111}}.dv{{font-size:15px;fill:#111}}.t{{font-size:21px;font-weight:700;fill:#111}}
.n{{font-size:14px;fill:#333}}.k{{font-size:14px;fill:#c2410c}}.cl{{stroke:#c2410c;stroke-width:1;stroke-dasharray:14 4 3 4}}
.col{{fill:#b8c0ca;stroke:#6b7785;stroke-dasharray:5 4}}.c{{font-size:12px;text-anchor:middle;fill:#3d4854}}.side{{font-size:15px;font-weight:700;fill:#6b7785;text-anchor:middle;letter-spacing:2px}}</style>
<rect width="{W}" height="{H}" fill="#fff"/>
<text x="30" y="36" class="t">Dell U3421WE base plate outline, top view</text>
<text x="30" y="58" class="n">traced from Dell's outline drawing · scaled so the overall size is Dell's 357.5 × 235; the drawing's proportions match that to within 1 %</text>
<text x="{OX}" y="{Y(-sag_r)-52}" class="side">REAR · WALL SIDE</text>
<path d="{path(xy,S,OX,OY)}" class="plate"/>
<line x1="{OX}" y1="{Y(-sag_r)-14}" x2="{OX}" y2="{Y(yF)+14}" class="cl"/>
<rect x="{OX-24*S}" y="{Y(-sag_r+8)}" width="{48*S}" height="{62*S}" rx="{16*S}" class="col"/><text x="{OX}" y="{Y(-sag_r+42)}" class="c">stand column</text>
{ext(-hW,Y(0)-2,Y(-sag_r)-34)}{ext(hW,Y(0)-2,Y(-sag_r)-34)}{hdim(Y(-sag_r)-28,-hW,hW,"A = 357.5 overall  (Dell spec)")}
{ext(-hB,Y(yF)+2,Y(yF)+44)}{ext(hB,Y(yF)+2,Y(yF)+44)}{hdim(Y(yF)+38,-hB,hB,f"B ≈ {B:.0f} across the front corners",20)}
{exh(-sag_r,X(0)+10,X(hA)+78)}{exh(yB,X(hB)+8,X(hA)+78)}{vdim(X(hA)+70,-sag_r,yB,"235 overall")}<text x="{X(hA)+78}" y="{(Y(-sag_r)+Y(yB))/2+24}" class="dv">(Dell spec)</text>
{vdim(X(0)+70,-sag_r,yF-sag_f,f"≈ {DEPTH-sag_f:.0f} on centre line")}
{exh(0,X(-hA)-58,X(-hA)-6)}{exh(-sag_r,X(-hA)-58,X(0)-10)}{vdim(X(-hA)-50,-sag_r,0,f"bows out ≈ {sag_r:.1f}",-1)}
{exh(yF,X(-hA)-58,X(-hB)-8)}{exh(yF-sag_f,X(-hA)-58,X(0)-10)}{vdim(X(-hA)-50,yF-sag_f,yF,f"hollow ≈ {sag_f:.1f}",-1)}
<text x="{X(-95)}" y="{Y(-sag_r)+44}" class="dt">rear arc R ≈ 640</text>
<text x="{X(-70)}" y="{Y(yF-sag_f)-16}" class="dt">front arc R ≈ 490</text>
<text x="{X(hA*0.80)}" y="{Y(yF*0.55)}" class="dt" transform="rotate({90-ang:.1f} {X(hA*0.80)} {Y(yF*0.55)})"></text>
<text x="{X(-hA+38)}" y="{Y(yF*0.52)}" class="dv">straight side,</text><text x="{X(-hA+38)}" y="{Y(yF*0.52)+18}" class="dv">≈ 15° from square</text>
<text x="{X(hA)-92}" y="{Y(0)+30}" class="dv">r ≈ 7</text><text x="{X(hB)-70}" y="{Y(yF)-30}" class="dv">r ≈ 3.5</text>
<text x="{OX}" y="{Y(yF)+84}" class="side">FRONT · SCREEN SIDE</text>
<text x="30" y="{H-48}" class="n">All dimensions in mm. Black = Dell spec. “≈” = measured from a low-resolution drawing (1 pixel = 1.2 mm), so expect ± 2 mm on those, including the corner radii.</text>
<text x="30" y="{H-26}" class="k">Worth checking on the real plate with a ruler: B, the centre-line depth, and the two corner radii.</text>
</svg>'''
open(os.path.join(DOCS,'outline-u3421we.svg'),'w').write(o)
# ---------- 1:1 template, two A4 portrait pages
def page(side):
    cx=195 if side<0 else 15; top=28+sag_r
    clipx=(cx-185,cx) if side<0 else (cx,cx+185)
    return f'''<div class="pg"><svg xmlns="http://www.w3.org/2000/svg" width="210mm" height="297mm" viewBox="0 0 210 297" font-family="Helvetica,Arial,sans-serif">
<clipPath id="c{side}"><rect x="{clipx[0]}" y="0" width="185" height="297"/></clipPath>
<path d="{path(xy,1,cx,top)}" fill="#eef1f4" stroke="#000" stroke-width="0.3" clip-path="url(#c{side})"/>
<line x1="{cx}" y1="8" x2="{cx}" y2="289" stroke="#c2410c" stroke-width="0.25" stroke-dasharray="6 2 1 2"/>
<text x="{cx+(-3 if side<0 else 3)}" y="273" font-size="3.2" fill="#c2410c" text-anchor="{"end" if side<0 else "start"}">centre line: cut here and tape to the other sheet</text>
<text x="{cx+side*90}" y="14" font-size="5" font-weight="700" text-anchor="middle">U3421WE base plate, 1:1, {"LEFT" if side<0 else "RIGHT"} half (top view)</text>
<text x="{cx+side*90}" y="21" font-size="3.6" text-anchor="middle">REAR / wall side is at the top · print at 100 % (“actual size”), no fit-to-page</text>
<g transform="translate({cx+side*90-50},{top+yF+22})"><line x1="0" y1="0" x2="100" y2="0" stroke="#000" stroke-width="0.3"/>
{''.join(f'<line x1="{i*10}" y1="-2" x2="{i*10}" y2="2" stroke="#000" stroke-width="0.3"/>' for i in range(11))}
<text x="50" y="7" font-size="3.6" text-anchor="middle">check: this bar must measure exactly 100 mm</text></g>
<text x="{cx+side*80}" y="{top+yF/2}" font-size="4" text-anchor="middle" fill="#555">set the monitor base on the grey area</text>
</svg></div>'''
html=f'<!doctype html><meta charset="utf-8"><style>@page{{size:A4 portrait;margin:0}}body{{margin:0}}.pg{{width:210mm;height:297mm;page-break-after:always;overflow:hidden}}svg{{display:block}}</style>{page(-1)}{page(1)}'
open(os.path.join(DOCS,'_template.html'),'w').write(html)
