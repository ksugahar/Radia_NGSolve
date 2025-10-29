#!python
import sys, os
from numpy import *
sys.path.append("C:/Program Files/Coreform Cubit 2023.11/bin")

import cubit
cubit.init(['-batch','-nojournal','-noecho','warning on','-nobanner'])

cubit.reset()
cubit.silent_cmd('Graphics Perspective off')
cubit.silent_cmd(r'import acis "./Coil_York.sat" separate_bodies attributes_on')
ids = cubit.get_last_id("volume")
cubit.silent_cmd('color surface in volume 1 blue')
cubit.silent_cmd('color surface in volume 2 tomato')

cubit.cmd('view from -100 500 500')
cubit.cmd('view at 0 500 500')
cubit.cmd('view up 0 1 0')

wy = 100
wz = 100
for dz in wz*arange(0.5,10.5,1):
  for dy in wy*arange(0.5,10.5,1):
    if (dz*0.5)+100>dy:
      wx = 600-41
      bk = cubit.brick(wx, wy, wz)
      cubit.move(bk, [wx/2+41,dy,dz])
    elif (dz*0.5)+200>dy:
      wx = 600-175
      bk = cubit.brick(wx, wy, wz)
      cubit.move(bk, [wx/2+175,dy,dz])
    elif (dz*1.1)+300>dy:
      wx = 600
      bk = cubit.brick(wx, wy, wz)
      cubit.move(bk, [wx/2,dy,dz])

