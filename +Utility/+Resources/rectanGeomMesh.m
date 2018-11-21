function [xn,idx,xc,area,grid_size,xe,neighbor_e,normal_e,xb,neighbor_b,normal_b] = rectanGeomMesh(N1,N2,L1,R1,L2,R2,r1,r2)
eps = 1e-5;
if (r1==1)
    t1 = linspace(L1,R1,N1);
else
if mod(N1,2)==0 
    n1 = N1/2-1;
    a0 = (R1-L1)*(1-r1)/(2-r1^n1-r1^(n1+1));
    s1 = a0*r1.^(0:n1); 
    s1 = [s1,fliplr(s1(1:length(s1)-1))]; 
else
    n1 = fix(N1/2);
    a0 = 0.5*(R1-L1)*(1-r1)/(1-r1^n1);
    s1 = a0*r1.^(0:n1-1);
    s1 = [s1,fliplr(s1)];
end

t1 = zeros(1,N1);
t1(1) = L1;

for i = 1:N1-1
    t1(i+1) = t1(i)+s1(i);
end
end
%--------------------------------------------------------------------------
if (r2==1)
    t2 = linspace(L2,R2,N2);
else
if mod(N2,2)==0 
    n2 = N2/2-1;
    a0 = (R2-L2)*(1-r2)/(2-r2^n2-r2^(n2+1));
    s2 = a0*r2.^(0:n2); 
    s2 = [s2,fliplr(s2(1:length(s2)-1))]; 
else
    n2 = fix(N2/2);
    a0 = 0.5*(R2-L2)*(1-r2)/(1-r2^n2);
    s2 = a0*r2.^(0:n2-1);
    s2 = [s2,fliplr(s2)];
end

t2 = zeros(1,N2);
t2(1) = L2;

for i = 1:N2-1
    t2(i+1) = t2(i)+s2(i);
end
end

[xx, yy] = meshgrid(t1,t2);
xn = [xx(:),yy(:)];          
%--------------------------------------------------------------------------
idx(:, 1) = zeros((N1-1)*(N2-1), 1);
for i = 1:N1-1
   idx((N2-1)*(i-1)+1:(N2-1)*(i-1)+N2-1, 1) = (1:N2-1)' + N2*(i-1);
end
idx(:, 2) = idx(:, 1) + N2;
idx(:, 3) = idx(:, 2) + 1;
idx(:, 4) = idx(:, 1) + 1;
% quadplot(idx, xn(:,1), xn(:,2),'k-'); axis equal; hold on;

%--------------------------------------------------------------------------
xMin = min(xn(:,1));
xMax = max(xn(:,1));
yMin = min(xn(:,2));
yMax = max(xn(:,2));
%--------------------------------------------------------------------------
%cell center points
xc =  ( xn(idx(:, 1), :) + xn(idx(:, 2), :) + xn(idx(:, 3), :) + xn(idx(:, 4), :) ) / 4;
Nc = length(xc(:,1));
%--------------------------------------------------------------------------
%edge center points
xe = [( xn(idx(:, 1), :) + xn(idx(:, 2), :) )*0.5; ...
      ( xn(idx(:, 2), :) + xn(idx(:, 3), :) )*0.5; ...
      ( xn(idx(:, 3), :) + xn(idx(:, 4), :) )*0.5; ...
      ( xn(idx(:, 4), :) + xn(idx(:, 1), :) )*0.5 ];

[xe,ia,ic] = unique(xe,'rows');
%--------------------------------------------------------------------------
%neighbor of xe
neighbor_e = zeros(length(xe(:,1)), 2);

for i =1:4*Nc
    if ic(i)~=0
        temp = find(ic(:)==ic(i));
        temp2 = mod(temp,Nc)';
        temp2((temp2==0)) = Nc;
        if length(temp) == 1
            neighbor_e(ic(i), 1) = temp2;
            neighbor_e(ic(i), 2) = -temp2;
        elseif length(temp) == 2
            neighbor_e(ic(i), :) = temp2;
        end
        ic(temp) = 0;
    end
end

%--------------------------------------------------------------------------
%boundary points
lgW = abs(xe(:,1)-xMin) < eps;
lgE = abs(xe(:,1)-xMax) < eps;
lgS = abs(xe(:,2)-yMin) < eps;
lgN = abs(xe(:,2)-yMax) < eps;
lgB = lgW | lgE | lgS | lgN;

xb = xe(lgB,:);
xe = xe(~lgB,:);

neighbor_b = neighbor_e(lgB,:);
neighbor_b(:,2) = [];
neighbor_e = neighbor_e(~lgB,:);

Ne = length(xe(:,1));
Nb = length(xb(:,1));
%--------------------------------------------------------------------------
%cell neighbor
neighbor_c = cell(Nc,1);
for i = 1:Nc
    temp1 = neighbor_e(:,1)==i;
    temp2 = neighbor_e(:,2)==i;
    temp3 = neighbor_b(:,1)==i;
    neighbor_c{i} = [neighbor_e(temp1,2)',neighbor_e(temp2,1)',Nc+find(temp3)'];
end
%--------------------------------------------------------------------------
%normal at xe and xb
normal = [ (xn(idx(:, 2), :) - xn(idx(:, 1), :)); ...
             (xn(idx(:, 3), :) - xn(idx(:, 2), :)); ...
             (xn(idx(:, 4), :) - xn(idx(:, 3), :)); ...
             (xn(idx(:, 1), :) - xn(idx(:, 4), :)) ];
normal = normal(ia,:);
normal = [-normal(:,2),normal(:,1)];      

normal_b = normal(lgB,:);
normal_e = normal(~lgB,:);

normal_b = -normal_b; %outward normal
%--------------------------------------------------------------------------
cnt = 0; %re-order nieghbor_e
for i = 1:Ne
    temp = sum(normal_e(i,:).*(xc(neighbor_e(i,2),:)-xc(neighbor_e(i,1),:)));
    if temp < 0
        t = neighbor_e(i,1);
        neighbor_e(i,1) = neighbor_e(i,2);
        neighbor_e(i,2) = t;
        cnt = cnt + 1;
    end
end
%--------------------------------------------------------------------------
%area
area = zeros(Nc, 1);
for i = 1:Nc
    area(i) = polyarea(xn(idx(i, :), 1), xn(idx(i, :), 2));
end
%--------------------------------------------------------------------------
%grid size
temp1 = sum((xn(idx(:, 2), :) - xn(idx(:, 1), :)).^2,2);
temp2 = sum((xn(idx(:, 3), :) - xn(idx(:, 2), :)).^2,2);

grid_size = sqrt(max(temp1,temp2));
%--------------------------------------------------------------------------
xt = [xc; xb];
Nt = length(xt(:,1));
% save('rectangleMeshD','xn','idx','xc','nodeType','area','grid_size','xe','neighbor_e','normal_e','xb','neighbor_b','normal_b');

end
