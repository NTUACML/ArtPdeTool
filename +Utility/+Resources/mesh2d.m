% Makes a simple 2D uniform mesh.
function mesh = mesh2d(ex, ey, lx, ly)       
    mesh.elm_number = ex*ey;
    mesh.node_number = (ex+1)*(ey+1);
    mesh.node = zeros(mesh.node_number,2);
    mesh.connect = zeros(mesh.elm_number, 4);
    
    xx = linspace(0,lx,ex+1);
    yy = linspace(0,ly,ey+1);    
    ct = 0;
    for j=1:ey+1
        for i=1:ex+1
            ct = ct + 1;
            mesh.node(ct,:) = [xx(i), yy(j)];            
        end
    end        
    ct = 0;
    for j=1:ey
        for i=1:ex
            ct = ct + 1;
            n0 = i + (j-1)*(ex+1);
            mesh.connect(ct,:) = [n0, n0+1, n0+ex+2, n0+ex+1];
        end
    end
end


