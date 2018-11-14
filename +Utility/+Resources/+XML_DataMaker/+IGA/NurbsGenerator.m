function NurbsGenerator(nurbs_name)

switch nurbs_name
    case 'Plane4'
        nurbs = nrb4surf([0.0 0.0 0.0],[1.0 0.0 0.0],[0.0 1.0 0.0],[1.0 1.0 0.0]);

        status = true;
    otherwise
        str = [nurbs_name, 'does not exist in the current library.'];
        disp(str);
        status = false;
end

if status
    OutPutFiles(nurbs);
end

end

function OutPutFiles(nurbs)
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

save('knots.mat', 'knots');
save('control_pnt.mat', 'control_pnt');
save('order.mat', 'order');
end

