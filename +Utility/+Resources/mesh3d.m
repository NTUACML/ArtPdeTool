% Makes a simple 3D uniform mesh.
function mesh = mesh3d(ex, ey, ez, lx, ly, lz)
nnx = ex+1 ;  
nny = (ex+1)*(ey+1);  

inc_u = 1; 
inc_v = nnx; 
inc_w = nny; 

node_pattern=[ 1 2 nnx+2 nnx+1 nny+1 nny+2 nny+nnx+2 nny+nnx+1 ]; 

mesh.connect = make_elem(node_pattern,ex,ey,ez,inc_u,inc_v,inc_w);

x=0:1/(ex):lx; 
y=0:1/(ey):ly; 
z=0:1/(ez):lz; 

% The sequence of x y is correct, since we have different sequence in our
% code.
[Y,X,Z] = meshgrid(y,x,z); 
mesh.node = [X(:) Y(:) Z(:)];

mesh.node_number = size(mesh.node,1);
mesh.element_number = size(mesh.connect,1);

end

function element = make_elem(node_pattern,num_u,num_v,num_w,inc_u,inc_v,inc_w)

element = zeros(num_u*num_v*num_w,size(node_pattern,2));

cnt = 0;
for k = 1:num_w
    for j = 1:num_v
        for i = 1:num_u
            cnt = cnt+1;
            inc = (i-1)*inc_u + (j-1)*inc_v + (k-1)*inc_w;
            element(cnt,:) = node_pattern + inc;
        end
    end
end

end
