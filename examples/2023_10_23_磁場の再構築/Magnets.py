import sys
import radia as rad
from numpy import *

p = []
Nx = 11
Ny = 11
x = linspace(-500,500,Nx)
y = linspace(-500,500,Ny)
xx, yy = meshgrid(x,y)
a = xx[0,1]-xx[0,0]
z0 = 100

for ny in range(Ny):
	for nx in range(Nx):
		p.append(rad.ObjRecMag([xx[nx,ny],yy[nx,ny],z0],[a,a,a],[Mx,My,Mz]))

g = rad.ObjCnt(p)

Bx = zeros((int(np),len(p)),dtype=float64)
By = zeros((int(np),len(p)),dtype=float64)
Bz = zeros((int(np),len(p)),dtype=float64)
Ax = zeros((int(np),len(p)),dtype=float64)
Ay = zeros((int(np),len(p)),dtype=float64)
Az = zeros((int(np),len(p)),dtype=float64)

for n in range(len(p)):
	Bx[:,n] = rad.FldLst(p[n],"Bx", [x1,y1,z1], [x2,y2,z2], int(np), "noarg")
	By[:,n] = rad.FldLst(p[n],"By", [x1,y1,z1], [x2,y2,z2], int(np), "noarg")
	Bz[:,n] = rad.FldLst(p[n],"Bz", [x1,y1,z1], [x2,y2,z2], int(np), "noarg")
	Ax[:,n] = rad.FldLst(p[n],"Ax", [x1,y1,z1], [x2,y2,z2], int(np), "noarg")
	Ay[:,n] = rad.FldLst(p[n],"Ay", [x1,y1,z1], [x2,y2,z2], int(np), "noarg")
	Az[:,n] = rad.FldLst(p[n],"Az", [x1,y1,z1], [x2,y2,z2], int(np), "noarg")

