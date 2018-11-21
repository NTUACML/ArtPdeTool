function Test_of_XML_Writer
clear all; clc; home
%% Document setting
project_name = 'ArtPDE';
doc_format = 'IGA';

%% Document create
doc_geo = com.mathworks.xml.XMLUtils.createDocument('Geometry');
doc_init = com.mathworks.xml.XMLUtils.createDocument('Initial');
doc_mat = com.mathworks.xml.XMLUtils.createDocument('Material');

%% Document node
doc_geo_node = doc_geo.getDocumentElement();
doc_geo_node.setAttribute('format',doc_format);

doc_init_node = doc_init.getDocumentElement();
doc_init_node.setAttribute('format',doc_format);

doc_mat_node = doc_mat.getDocumentElement();
doc_mat_node.setAttribute('format',doc_format);

%% Data create (Geometry part)
doc_handle = doc_geo;

% /Unit
unit_node = DataNodeCreate('Unit', doc_geo_node, doc_handle);
unit_node.setAttribute('format','isoparametric');
unit_node.setAttribute('type','nurbs');

% /Unit/Patch (Domain)
patch_node = DataNodeCreate('Patch', unit_node, doc_handle);
patch_node.setAttribute('region','Domain');
patch_node.setAttribute('name','domain_1');

% /Unit/Patch/NURBS
nurbs_node = DataNodeCreate('NURBS', patch_node, doc_handle);
nurbs_node.setAttribute('type','Surface');

% /Unit/Patch/NURBS/ControlPoint
CTPT_node = DataNodeCreate('ControlPoint', nurbs_node, doc_handle);

% /Unit/Patch/NURBS/ControlPoint/Point
load('control_pnt.mat');

for i = 1 : size(control_pnt, 1)
    point_node = DataNodeCreate('Point', CTPT_node, doc_handle);
    point_row_str = num2str(control_pnt(i, :));
    point_node.appendChild(doc_handle.createTextNode(point_row_str));
end

% /Unit/Patch/NURBS/Order
load('order.mat');
order_node = DataNodeCreate('Order', nurbs_node, doc_handle);
order_str = num2str(order);
order_node.appendChild(doc_handle.createTextNode(order_str));

% /Unit/Patch/NURBS/Knot
knot_node = DataNodeCreate('Knot', nurbs_node, doc_handle);

% /Unit/Patch/NURBS/Knot/Vector
load('knots.mat');

for i = 1 : size(knots, 2)
    vector_node = DataNodeCreate('Vector', knot_node, doc_handle);
    knot_row_str = num2str(knots{i});
    vector_node.appendChild(doc_handle.createTextNode(knot_row_str));
    vector_node.setAttribute('dof',num2str(length(knots{i})));
end

% /Unit/Patch (Boundary)
patch_node = DataNodeCreate('Patch', unit_node, doc_handle);
patch_node.setAttribute('region','Boundary');
patch_node.setAttribute('name','top');

% /Unit/Patch/NURBS
nurbs_node = DataNodeCreate('NURBS', patch_node, doc_handle);
nurbs_node.setAttribute('type','Surface');

% /Unit/Patch/NURBS/ControlPoint
CTPT_node = DataNodeCreate('ControlPoint', nurbs_node, doc_handle);

% /Unit/Patch/NURBS/ControlPoint/Point
control_pnt = [0.1 0.2 0.0 1.0;
              0.0 1.0 0.0 1.0;];
for i = 1 : size(control_pnt, 1)
    point_node = DataNodeCreate('Point', CTPT_node, doc_handle);
    point_row_str = num2str(control_pnt(i, :));
    point_node.appendChild(doc_handle.createTextNode(point_row_str));
end

% /Unit/Patch/NURBS/Order
order_node = DataNodeCreate('Order', nurbs_node, doc_handle);
order_str = num2str([1 1]);
order_node.appendChild(doc_handle.createTextNode(order_str));

% /Unit/Patch/NURBS/Knot
knot_node = DataNodeCreate('Knot', nurbs_node, doc_handle);

% /Unit/Patch/NURBS/Knot/Vector
knots = {[0 0 1 1];
             [1]};
for i = 1 : size(knots, 1)
    vector_node = DataNodeCreate('Vector', knot_node, doc_handle);
    knot_row_str = num2str(knots{i});
    vector_node.appendChild(doc_handle.createTextNode(knot_row_str));
    vector_node.setAttribute('dof',num2str(length(knots{i})));
end



%% Document write
file_name_geo = [project_name, '_', doc_format ,'.art_geometry'];
xmlwrite(file_name_geo, doc_geo);

file_name_init = [project_name, '_', doc_format,'.art_initial'];
xmlwrite(file_name_init, doc_init);

file_name_mat = [project_name, '_', doc_format,'.art_material'];
xmlwrite(file_name_mat, doc_mat);


end

%% Using Function
function current_node = DataNodeCreate(name, upper_node, doc_handle)
    current_node = doc_handle.createElement(name);
    upper_node.appendChild(current_node);
end