% Makes a simple 3D uniform mesh.
function mesh = mesh3d(ex, ey, ez, lx, ly, lz)
nnx = ex+1 ;  
nny = (ex+1)*(ey+1);  

inc_u = 1; 
inc_v = nnx; 
inc_w = nny; 

node_pattern=[ 1 2 nnx+2 nnx+1 nny+1 nny+2 nny+nnx+2 nny+nnx+1 ]; 

mesh.connect = make_elem(node_pattern,ex,ey,ez,inc_u,inc_v,inc_w,nnx);

x=0:1/(ex):lx; 
y=0:1/(ey):ly; 
z=0:1/(ez):lz; 

[X,Y,Z] = meshgrid(x,y,z); 

X1=reshape(X,length(x)*length(y)*length(z),1); 
Y1=reshape(Y,length(x)*length(y)*length(z),1); 
Z1=reshape(Z,length(x)*length(y)*length(z),1);

mesh.node=[X1 Y1 Z1];

end

function element = make_elem(node_pattern,num_u,num_v,num_w,inc_u,inc_v,inc_w,nnx)

inc = zeros(1,size(node_pattern,2));
e=1;
element=zeros(num_u*num_v*num_w,size(node_pattern,2));
for row=1:num_v*num_u
    for col=1:num_w
        element(e,:)=node_pattern+inc;
        inc=inc+inc_u;
        e=e+1;
    end
    
    inc = row*inc_v;
    if mod(e-1,num_u*num_v)==0
        node_pattern =    node_pattern + nnx;
    end
end
end

