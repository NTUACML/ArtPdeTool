clc; clear; close all;

%% Include package
import Utility.BasicUtility.*
import Utility.NurbsUtility.*
import Geometry.*
import Domain.*
%% Geometry data input
xml_path = './ArtPDE_IGA_Lens_bottom_left.art_geometry';

geo = GeometryBuilder.create('IGA', 'XML', xml_path);
nurbs_data = geo.topology_data_{1}.domain_patch_data_.nurbs_data_;

%% Domain create
iga_domain = DomainBuilder.create('IGA');

%% Basis create
nurbs_basis = iga_domain.generateBasis(geo.topology_data_{1});

%% Nurbs tools create
nurbs_tool = NurbsTools(nurbs_basis);

%% Knot insert
inserted_knot = {[0.125 0.223] [0.44 0.78 0.9]};


%% Generate nurbs_tool_box_object
tensor_tool = TensorProduct(num2cell(nurbs_data.basis_number_));
coefs = zeros(4,nurbs_data.basis_number_(1), nurbs_data.basis_number_(2));

for i = 1:tensor_tool.total_num_
    index = tensor_tool.to_local_index(i);
    
    coefs(4, index{1}, index{2}) = nurbs_data.control_points_(i,4);   
    coefs(1:3, index{1}, index{2}) = nurbs_data.control_points_(i,4) * nurbs_data.control_points_(i,1:3);
end

nurbs = nrbmak(coefs, nurbs_data.knot_vectors_);

%% Plot nurbs using the nurbs_tool_box_object
figure; hold on; grid on; axis equal;
nrbplot(nurbs,[21 21]); view([0 90]);
hold off;

new_nurbs = nrbkntins(nurbs, inserted_knot); 

figure; hold on; grid on; axis equal;
nrbplot(new_nurbs,[21 21]); view([0 90]);
hold off;

%% compare control points
index = 0;
for j = 1:size(nurbs.coefs,3)
    for i = 1:size(nurbs.coefs,2)  
        index = index + 1;
        temp = nurbs.coefs(:, i, j)';
        temp(1:3) = temp(1:3)/ temp(4);
        
        disp(temp - nurbs_data.control_points_(index,:));
        disp('------------------------------------')
    end
end

nurbs_tool.knotInsertion(inserted_knot);

disp('After knot insertion');
index = 0;
for j = 1:size(new_nurbs.coefs,3)
    for i = 1:size(new_nurbs.coefs,2)
        index = index + 1;
        temp = new_nurbs.coefs(:, i, j)';
        temp(1:3) = temp(1:3)/ temp(4);
        
        disp(temp - nurbs_data.control_points_(index,:));
        disp('------------------------------------')
    end
end

% xi = rand(1,2);
% 
% [p_1,w_1] = nrbeval(nurbs, num2cell(xi)); 
% [p_2,w_2] = nrbeval(new_nurbs, num2cell(xi));
% 
% p_1 = p_1/w_1;
% p_2 = p_2/w_1;
% 
% disp(p_1');
% disp(p_2');


% nurbs_data.dispControlPoints();
% nurbs_data.dispKnotVectors();



disp('end');

