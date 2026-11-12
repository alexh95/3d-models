"""Trace the U3421WE base plate from Dell's "Outline Dimension" top view.

Usage: python trace_dell_outline.py SCREENSHOT.png

This is the script that produced the outline numbers in the .scad files.
It is specific to that one screenshot (812 x 554 px): the pixel windows
below say where the plate sits in the image. It finds the plate's light
grey fill, fits a circle to the rear and front edges and a line to each
side, then scales the result by Dell's published 357.5 x 235 mm.

The screenshot is not in the repository. Needs: pillow, numpy.
"""
import sys
from PIL import Image
import numpy as np
a=np.asarray(Image.open(sys.argv[1]).convert('RGB')).astype(float); g=a.mean(axis=2)
H,W=g.shape
plate=(g>205)&(g<233)
def sub(v_out,v_in):  # fraction of boundary pixel covered by plate
    return np.clip((255-v_out)/(255-221.0),0,1)
rear=[];front=[]
for x in range(280,592):
    col=g[:,x]; pm=plate[:,x]
    # rear edge: scan down from y=150
    for y in range(150,260):
        if pm[y:y+5].all() and (g[y-6:y-1,x]>250).all():
            # boundary pixel is y-1 (partially covered) 
            rear.append((x, y - sub(col[y-1],0))); break
    for y in range(385,300,-1):
        if pm[y-4:y+1].all() and (g[y+2:y+7,x]>250).all():
            front.append((x, y+1 + sub(col[y+1],0))); break
left=[];right=[]
for y in range(175,372):
    row=g[y,:]; pm=plate[y,:]
    for x in range(270,360):
        if pm[x:x+5].all() and (row[x-6:x-1]>250).all():
            left.append((x - sub(row[x-1],0), y)); break
    for x in range(600,520,-1):
        if pm[x-4:x+1].all() and (row[x+2:x+7]>250).all():
            right.append((x+1 + sub(row[x+1],0), y)); break
rear=np.array(rear);front=np.array(front);left=np.array(left);right=np.array(right)
print(len(rear),len(front),len(left),len(right))
print('rear x range',rear[:,0].min(),rear[:,0].max(),' y range',rear[:,1].min(),rear[:,1].max())
print('front x range',front[:,0].min(),front[:,0].max(),' y range',front[:,1].min(),front[:,1].max())
print('left y range',left[:,1].min(),left[:,1].max(),' x',left[:,0].min(),left[:,0].max())
print('right y range',right[:,1].min(),right[:,1].max(),' x',right[:,0].min(),right[:,0].max())

# ---- fits
def circ(p):
    x,y=p[:,0],p[:,1]; A=np.c_[2*x,2*y,np.ones(len(x))]; b=x*x+y*y
    c,*_=np.linalg.lstsq(A,b,rcond=None); cx,cy=c[0],c[1]; r=np.sqrt(c[2]+cx*cx+cy*cy)
    res=np.hypot(x-cx,y-cy)-r; return cx,cy,r,res
def robust(p,fit,k=3):
    for _ in range(4):
        out=fit(p); res=out[-1]; keep=np.abs(res)<max(0.6,2.5*res.std()); p=p[keep]
    return out,p
r=rear[(rear[:,0]>297)&(rear[:,0]<574)&((rear[:,0]<418)|(rear[:,0]>464))]
f=front[(front[:,0]>340)&(front[:,0]<532)]
(rc,rp)=robust(r,circ); (fc,fp)=robust(f,circ)
print('rear circle  cx %.1f cy %.1f R %.1f  rms %.2f n %d'%(rc[0],rc[1],rc[2],rc[3].std(),len(rp)))
print('front circle cx %.1f cy %.1f R %.1f  rms %.2f n %d'%(fc[0],fc[1],fc[2],fc[3].std(),len(fp)))
def line(p):  # x = m*y + c
    m,c=np.polyfit(p[:,1],p[:,0],1); res=p[:,0]-(m*p[:,1]+c); return m,c,res
l=left[(left[:,1]>195)&(left[:,1]<355)]; rt=right[(right[:,1]>195)&(right[:,1]<355)]
(lc,lp)=robust(l,line); (rl,rpp)=robust(rt,line)
print('left  line x=%.4f*y+%.2f rms %.2f n %d angle %.2f deg'%(lc[0],lc[1],lc[2].std(),len(lp),np.degrees(np.arctan(lc[0]))))
print('right line x=%.4f*y+%.2f rms %.2f n %d angle %.2f deg'%(rl[0],rl[1],rl[2].std(),len(rpp),np.degrees(np.arctan(rl[0]))))
# intersection of side lines
yi=(rl[1]-lc[1])/(lc[0]-rl[0]); xi=lc[0]*yi+lc[1]; print('side lines meet at x %.1f y %.1f'%(xi,yi))
# symmetric axis
xc=(rc[0]+fc[0]+xi)/3; print('axis x ~',xc)
# constrained fits: concentric circles w/ centre on axis
# corners: intersect side lines with circles
def inter(m,c,cx,cy,R,sign):
    # points on line x=m*y+c with (x-cx)^2+(y-cy)^2=R^2
    A=m*m+1; B=2*(m*(c-cx)-cy); C=(c-cx)**2+cy*cy-R*R; d=np.sqrt(B*B-4*A*C)
    ys=[(-B-d)/(2*A),(-B+d)/(2*A)]; y=min(ys) if sign<0 else max(ys); return m*y+c,y
RL=inter(lc[0],lc[1],rc[0],rc[1],rc[2],-1); RR=inter(rl[0],rl[1],rc[0],rc[1],rc[2],-1)
FL=inter(lc[0],lc[1],fc[0],fc[1],fc[2],-1); FR=inter(rl[0],rl[1],fc[0],fc[1],fc[2],-1)
print('corners RL',np.round(RL,1),'RR',np.round(RR,1),'FL',np.round(FL,1),'FR',np.round(FR,1))
wr=RR[0]-RL[0]; wf=FR[0]-FL[0]
rear_apex=rc[1]-rc[2]; front_apex=fc[1]-fc[2]
print('rear width px %.1f front width px %.1f'%(wr,wf))
print('rear apex y %.1f, rear corner y %.1f, front apex y %.1f, front corner y %.1f'%(rear_apex,(RL[1]+RR[1])/2,front_apex,(FL[1]+FR[1])/2))
depth_overall=(FL[1]+FR[1])/2-rear_apex; depth_center=front_apex-rear_apex
print('overall depth px %.1f  centre depth px %.1f'%(depth_overall,depth_center))
sw=357.5/wr; sd=235/depth_overall
print('scale from width %.4f mm/px ; from depth %.4f mm/px ; ratio %.3f'%(sw,sd,sw/sd))
for s,name in((sw,'width-scale'),(sd,'depth-scale'),((sw+sd)/2,'mean')):
    print(name,': A %.1f B %.1f overall depth %.1f centre depth %.1f Rrear %.0f Rfront %.0f  rear sag %.1f front sag %.1f side angle %.1f'%(
      wr*s,wf*s,depth_overall*s,depth_center*s,rc[2]*s,fc[2]*s,((RL[1]+RR[1])/2-rear_apex)*s,((FL[1]+FR[1])/2-front_apex)*s,np.degrees(np.arctan((rl[0]-lc[0])/2))*-1))
print('centre offsets: rear cy %.1f front cy %.1f apex-of-sides y %.1f'%(rc[1],fc[1],yi))
