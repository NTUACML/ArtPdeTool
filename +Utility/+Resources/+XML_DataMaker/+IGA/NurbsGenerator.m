function nurbs_out = NurbsGenerator(nurbs_name)

switch nurbs_name
    case 'Plane4'
        nurbs = nrb4surf([0.0 0.0 0.0],[1.0 0.0 0.0],[0.0 1.0 0.0],[1.0 1.0 0.0]);
        status = true;
    case 'Plane4_refined'
        nurbs = nrb4surf([0.0 0.0 0.0],[1.0 0.0 0.0],[0.0 1.0 0.0],[1.0 1.0 0.0]);
        nurbs = nrbdegelev(nurbs, [1 1]);
        t = linspace(0.1, 0.9, 9);
        nurbs = nrbkntins(nurbs,{t, t});
        status = true;
    case 'Plane_quarter_hole'
        nurbs = Plane_quarter_hole();
        t = linspace(0.1, 0.9, 9);
        nurbs = nrbkntins(nurbs,{t, t});
        status = true;
    otherwise
        str = [nurbs_name, 'does not exist in the current library.'];
        disp(str);
        status = false;
end

if status
    nurbs_out = OutPutFiles(nurbs);
end

end

function nurbs_out= OutPutFiles(nurbs)
import Utility.BasicUtility.TensorProduct

% nurbs knots
knots = nurbs.knots;

% nurbs control point
geo_dim = size(knots, 2);
control_pnt = zeros(prod(nurbs.number), 4);
switch geo_dim
    case 1
        TD_1 = TensorProduct({nurbs.number(1)});
        for k = 1:TD_1.total_num_
            local_index = TD_1.to_local_index(k);
            control_pnt(k,:) = nurbs.coefs(:, local_index{1})';
        end
    case 2
        TD_2 = TensorProduct({nurbs.number(1) nurbs.number(2)});
        for k = 1:TD_2.total_num_
            local_index = TD_2.to_local_index(k);
            control_pnt(k,:) = nurbs.coefs(:, local_index{1}, local_index{2})';
        end
    case 3
        TD_3 = TensorProduct({nurbs.number(1) nurbs.number(2) nurbs.number(3)});
        for k = 1:TD_3.total_num_
            local_index = TD_3.to_local_index(k);
            control_pnt(k,:) = nurbs.coefs(:, local_index{1}, local_index{2}, local_index{3})';
        end
end

control_pnt(:,1) = control_pnt(:,1)./control_pnt(:,4);
control_pnt(:,2) = control_pnt(:,2)./control_pnt(:,4);
control_pnt(:,3) = control_pnt(:,3)./control_pnt(:,4);

% nurbs order
order = nurbs.order-1;

import Utility.BasicUtility.PointList
control_point_list = PointList(control_pnt);

import Utility.NurbsUtility.Nurbs
nurbs_out = Nurbs(knots, order, control_point_list);

end


function nurbs = Plane_quarter_hole
knots = {[0 0 0 0.5 1 1 1]  [0 0 0 1 1 1]};
coefs  = [zeros(3,4,3); ones(1,4,3)];

coefs(1:2,1,1) = [-1 0];            coefs(4,1,1) = 1;
coefs(1:2,2,1) = [-1 sqrt(2)-1];    coefs(4,2,1) = (1+1/sqrt(2))/2;
coefs(1:2,3,1) = [1-sqrt(2) 1];     coefs(4,3,1) = (1+1/sqrt(2))/2;
coefs(1:2,4,1) = [0 1];             coefs(4,4,1) = 1;

coefs(1:2,1,2) = [-2.5 0];          coefs(4,1,2) = 1;
coefs(1:2,2,2) = [-2.5 0.75];       coefs(4,2,2) = 1;
coefs(1:2,3,2) = [-0.75 2.5];       coefs(4,3,2) = 1;
coefs(1:2,4,2) = [0 2.5];           coefs(4,4,2) = 1;

coefs(1:2,1,3) = [-4 0];            coefs(4,1,3) = 1;
coefs(1:2,2,3) = [-4 4];            coefs(4,2,3) = 1;
coefs(1:2,3,3) = [-4 4];            coefs(4,3,3) = 1;
coefs(1:2,4,3) = [0 4];             coefs(4,4,3) = 1;

coefs(1,:,:) = -coefs(1,:,:);

for i = 1:3
    coefs(i,:,:) = coefs(i,:,:).*coefs(4,:,:);
end

nurbs = nrbmak(coefs,knots);

end
