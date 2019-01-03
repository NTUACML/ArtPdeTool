function Demo2VTK
clc; clear; close all;

import Utility.Resources.*

load wind 
[cu,cv,cw] = curl(x, y, z, u, v, w); 
div = divergence(x, y, z, u, v, w); 
vtkwrite('wind.vtk', 'structured_grid', x, y, z, ... 
'vectors', 'vector_field', u, v, w, 'vectors', 'vorticity', cu, cv, cw, 'scalars', 'divergence', div);



end

