"""Draw the dimensioned cross-section of the seat: docs/seat-section.svg.

Usage: python seat_drawing.py     then:  node tools/render_docs.js

The numbers on the second line must match the "Seat" and "Dell base"
parameters in interface_check.scad.
"""
import os
W=1160;H=640;k=40;x0=480;yf=420
ov=1.2;bh=4.56;li=0.8;lw=1.8;lh=4.2;dt=2.0;r=0.6;lo=li-lw
X=lambda mm:x0+mm*k; Y=lambda mm:yf-mm*k
def hd(y,a,b,lab,side):
    tx=X(a)-10 if side<0 else X(b)+10
    return f'<line x1="{X(a)}" y1="{y}" x2="{X(b)}" y2="{y}" class="d" marker-start="url(#a)" marker-end="url(#a)"/><text x="{tx}" y="{y+5}" class="{"dr" if side<0 else "lab"}">{lab}</text>'
def vd(x,a,b,lab,lab2=''):
    o=f'<line x1="{x}" y1="{Y(a)}" x2="{x}" y2="{Y(b)}" class="d" marker-start="url(#a)" marker-end="url(#a)"/><text x="{x-10}" y="{(Y(a)+Y(b))/2+(0 if lab2 else 5)}" class="dr">{lab}</text>'
    if lab2: o+=f'<text x="{x-10}" y="{(Y(a)+Y(b))/2+18}" class="dr2">{lab2}</text>'
    return o
R=1060; rp=r*k
zig=lambda x,y1,y2:f'L{x},{y1} '+' '.join(f'L{x-(8 if i%2 else 0)},{y1+(y2-y1)*i/6:.1f}' for i in range(1,7))
yb=Y(-dt)
svg=f'''<svg xmlns="http://www.w3.org/2000/svg" width="{W}" height="{H}" viewBox="0 0 {W} {H}" font-family="Helvetica,Arial,sans-serif">
<defs><marker id="a" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="7" markerHeight="7" orient="auto-start-reverse"><path d="M0,0 L10,5 L0,10 z" fill="#444"/></marker></defs>
<style>.top{{fill:#d3d8de;stroke:#1f2933;stroke-width:2}}.blk{{fill:#4a4f55;stroke:#1f2933;stroke-width:2}}.part{{fill:#8fbce6;stroke:#1d4f7c;stroke-width:2}}
.d{{stroke:#444;stroke-width:1.2}}.e{{stroke:#999;stroke-width:1}}.dr{{font-size:15px;text-anchor:end;fill:#111}}.dr2{{font-size:13px;text-anchor:end;fill:#555}}
.t{{font-size:21px;font-weight:700;fill:#111}}.n{{font-size:14px;fill:#333}}.lab{{font-size:15px;fill:#111}}.labw{{font-size:15px;fill:#fff}}
.fp{{stroke:#c2410c;stroke-width:1.3;stroke-dasharray:7 4}}.fpt{{font-size:13px;fill:#c2410c}}</style>
<rect width="{W}" height="{H}" fill="#fff"/>
<text x="30" y="36" class="t">Seat, third version: how the Dell base sits on top of the riser</text>
<text x="30" y="58" class="n">cross-section through the edge, same all the way round · outside of the riser is on the left · 40× scale, dimensions in mm</text>
<path d="M{X(0)},{Y(bh)} H{R} {zig(R,Y(bh),Y(bh)-110)} H{X(0)} Z" class="top"/>
<text x="{X(6)}" y="{Y(bh)-50}" class="lab">Dell top plate (silver)</text>
<path d="M{X(ov)},{Y(0)} H{R} {zig(R,Y(0),Y(bh))} H{X(ov)} Z" class="blk"/>
<text x="{X(6)}" y="{Y(bh/2)+5}" class="labw">Dell lower body (black)</text>
<path d="M{X(lo)},{Y(lh)} H{X(li-r)} A{rp},{rp} 0 0 1 {X(li)},{Y(lh-r)} V{Y(r)} A{rp},{rp} 0 0 0 {X(li+r)},{Y(0)} H{R} {zig(R,Y(0),yb)} H{X(lo)} Z" class="part"/>
<text x="{X(6)}" y="{Y(-dt/2)+5}" class="lab">printed deck: top of the riser</text>
<line x1="{X(0)}" y1="78" x2="{X(0)}" y2="{H-22}" class="fp"/><text x="{X(0)+8}" y="92" class="fpt">edge of the silver plate</text>
{vd(X(lo)-120,0,lh,"lip 4.2")}
{vd(X(lo)-250,0,bh,"≈ 4.6 or more","6 cards, as measured")}
<line x1="{X(lo)-260}" y1="{Y(bh)}" x2="{X(0)-4}" y2="{Y(bh)}" class="e"/><line x1="{X(lo)-260}" y1="{Y(0)}" x2="{X(lo)-4}" y2="{Y(0)}" class="e"/><line x1="{X(lo)-130}" y1="{Y(lh)}" x2="{X(lo)-4}" y2="{Y(lh)}" class="e"/>
<line x1="{X(-0.05)}" y1="{Y(lh-0.12)}" x2="{X(lo)-22}" y2="{Y(lh)-70}" class="e"/><text x="{X(lo)-26}" y="{Y(lh)-74}" class="dr">round-over r 0.6</text>
<line x1="{X(li+0.2)}" y1="{Y(0.2)}" x2="{X(lo)-22}" y2="{Y(1.2)}" class="e"/><text x="{X(lo)-26}" y="{Y(1.2)+5}" class="dr">cove r 0.6</text>
<line x1="{X(-0.8)}" y1="{Y((bh+lh)/2)}" x2="{X(lo)-22}" y2="{Y(lh)-28}" class="e"/><text x="{X(lo)-26}" y="{Y(lh)-24}" class="dr">air gap</text>
<line x1="{X(lo)}" y1="{yb+4}" x2="{X(lo)}" y2="{yb+100}" class="e"/><line x1="{X(li)}" y1="{yb+4}" x2="{X(li)}" y2="{yb+48}" class="e"/><line x1="{X(ov)}" y1="{yb+4}" x2="{X(ov)}" y2="{yb+100}" class="e"/>
{hd(yb+34,lo,li,"lip 1.8 thick",-1)}{hd(yb+34,li,ov,"side play 0.4 (was 1.0, too loose)",1)}
{hd(yb+86,lo,0,"1.0 outside the plate edge",-1)}{hd(yb+86,0,ov,"overhang 1.2, from the first test",1)}
</svg>'''
open(os.path.join(os.path.dirname(os.path.abspath(__file__)),'..','docs','seat-section.svg'),'w',encoding='utf-8').write(svg)
