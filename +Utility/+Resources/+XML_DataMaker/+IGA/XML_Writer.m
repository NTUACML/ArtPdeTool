function XML_Writer
clear all; clc; home
%% Generate nurbs object
import Utility.Resources.XML_DataMaker.IGA.NurbsGenerator
% nurbs = NurbsGenerator('Plane4');
% nurbs = NurbsGenerator('Plane4_refined');
nurbs = NurbsGenerator('Plane_quarter_hole');

%% Document setting
project_name = 'ArtPDE';
doc_format = 'IGA';
version = '1.1';

import Utility.NurbsUtility.NurbsType
switch nurbs.type_
    case NurbsType.Solid
        geo_dim = '3';
    case NurbsType.Plane
        geo_dim = '2';
    case NurbsType.Surface
        geo_dim = '2';
    case NurbsType.Curve
        geo_dim = '1';
end

%% Document create
doc_geo = com.mathworks.xml.XMLUtils.createDocument('Geometry');
doc_init = com.mathworks.xml.XMLUtils.createDocument('Initial');
doc_mat = com.mathworks.xml.XMLUtils.createDocument('Material');

%% Document node
doc_geo_node = doc_geo.getDocumentElement();
doc_geo_node.setAttribute('version',version);
doc_geo_node.setAttribute('dim', geo_dim);

doc_init_node = doc_init.getDocumentElement();
doc_init_node.setAttribute('version',version);

doc_mat_node = doc_mat.getDocumentElement();
doc_mat_node.setAttribute('version',version);

%% Data create (Geometry part)
doc_handle = doc_geo;

% /Unit
unit_node = DataNodeCreate('Unit', doc_geo_node, doc_handle);
unit_node.setAttribute('format','NURBS');

% /Unit/Patch (Domain)
patch_node = DataNodeCreate('Patch', unit_node, doc_handle);
patch_node.setAttribute('region','Domain');
patch_node.setAttribute('name','domain_1');
% patch_node.setAttribute('type','Surface');

% /Unit/Patch/ControlPoint
CTPT_node = DataNodeCreate('ControlPoint', patch_node, doc_handle);
CTPT_node.setAttribute('dim','3');

% /Unit/Patch/ControlPoint/Point
point_data = nurbs.control_points_(:,:);

for i = 1 : size(point_data, 1)
    point_node = DataNodeCreate('Point', CTPT_node, doc_handle);
    point_row_str = num2str(point_data(i, :));
    point_node.appendChild(doc_handle.createTextNode(point_row_str));
end

% /Unit/Patch/Order
order_node = DataNodeCreate('Order', patch_node, doc_handle);
order_str = num2str(nurbs.order_);
order_node.appendChild(doc_handle.createTextNode(order_str));

% /Unit/Patch/Knot
knot_node = DataNodeCreate('Knot', patch_node, doc_handle);

% /Unit/Patch/Knot/Vector
knot_data = nurbs.knot_vectors_;

for i = 1 : size(knot_data, 2)
    vector_node = DataNodeCreate('Vector', knot_node, doc_handle);
    knot_row_str = num2str(knot_data{i});
    vector_node.appendChild(doc_handle.createTextNode(knot_row_str));
    vector_node.setAttribute('dof',num2str(length(knot_data{i})));
end

% /Unit/Patch (Boundary)
switch geo_dim
    case '3'
        
    case '2'
        % determine the knots prepared to be inserted into the knot vector
        xi_i = unique(nurbs.knot_vectors_{1}); 
        eta_i = unique(nurbs.knot_vectors_{2});
        
        bool = abs(xi_i) < eps | abs(xi_i-1) < eps;
        xi_i = xi_i(~bool);
        
        bool = abs(eta_i) < eps | abs(eta_i-1) < eps;
        eta_i = eta_i(~bool);
        
        
        % top boundary nurbs patch
        patch_node = DataNodeCreate('Patch', unit_node, doc_handle);
        patch_node.setAttribute('region','Boundary');
        patch_node.setAttribute('name','top');
        
        % /Unit/Patch/ControlPoint
        CTPT_node = DataNodeCreate('ControlPoint', patch_node, doc_handle);
        CTPT_node.setAttribute('dim','3');

        % /Unit/Patch/ControlPoint/Point
%         point_data = [0 1 0 1;
%                       1 1 0 1];
        crv = nrbline([0 1 0]',[1 1 0]');   
        crv = nrbkntins(crv,xi_i);
      
        point_data = crv.coefs';       
        for i = 1 : size(point_data, 1)
            point_node = DataNodeCreate('Point', CTPT_node, doc_handle);
            point_row_str = num2str(point_data(i, :));
            point_node.appendChild(doc_handle.createTextNode(point_row_str));
        end
        
        % /Unit/Patch/Order
        order_node = DataNodeCreate('Order', patch_node, doc_handle);
        order_str = num2str(crv.order-1);
        order_node.appendChild(doc_handle.createTextNode(order_str));
        
        % /Unit/Patch/Knot
        knot_node = DataNodeCreate('Knot', patch_node, doc_handle);
        
        % /Unit/Patch/Knot/Vector
        knot_data = {crv.knots};
        for i = 1 : size(knot_data, 1)
            vector_node = DataNodeCreate('Vector', knot_node, doc_handle);
            knot_row_str = num2str(knot_data{i});
            vector_node.appendChild(doc_handle.createTextNode(knot_row_str));
            vector_node.setAttribute('dof',num2str(length(knot_data{i})));
        end 
        
        % bottom boundary nurbs patch
        patch_node = DataNodeCreate('Patch', unit_node, doc_handle);
        patch_node.setAttribute('region','Boundary');
        patch_node.setAttribute('name','bottom');
        
        % /Unit/Patch/ControlPoint
        CTPT_node = DataNodeCreate('ControlPoint', patch_node, doc_handle);
        CTPT_node.setAttribute('dim','3');

        % /Unit/Patch/ControlPoint/Point
%         point_data = [0 0 0 1;
%                       1 0 0 1];
        crv = nrbline([0 0 0]',[1 0 0]');   
        crv = nrbkntins(crv,xi_i);
      
        point_data = crv.coefs';                            
        for i = 1 : size(point_data, 1)
            point_node = DataNodeCreate('Point', CTPT_node, doc_handle);
            point_row_str = num2str(point_data(i, :));
            point_node.appendChild(doc_handle.createTextNode(point_row_str));
        end
        
        % /Unit/Patch/Order
        order_node = DataNodeCreate('Order', patch_node, doc_handle);
        order_str = num2str(crv.order-1);
        order_node.appendChild(doc_handle.createTextNode(order_str));
        
        % /Unit/Patch/Knot
        knot_node = DataNodeCreate('Knot', patch_node, doc_handle);
        
        % /Unit/Patch/Knot/Vector
        knot_data = {crv.knots};
        for i = 1 : size(knot_data, 1)
            vector_node = DataNodeCreate('Vector', knot_node, doc_handle);
            knot_row_str = num2str(knot_data{i});
            vector_node.appendChild(doc_handle.createTextNode(knot_row_str));
            vector_node.setAttribute('dof',num2str(length(knot_data{i})));
        end 
        
        % top boundary nurbs patch
        patch_node = DataNodeCreate('Patch', unit_node, doc_handle);
        patch_node.setAttribute('region','Boundary');
        patch_node.setAttribute('name','left');
        
        % /Unit/Patch/ControlPoint
        CTPT_node = DataNodeCreate('ControlPoint', patch_node, doc_handle);
        CTPT_node.setAttribute('dim','3');

        % /Unit/Patch/ControlPoint/Point
%         point_data = [0 0 0 1;
%                       0 1 0 1];
        crv = nrbline([0 0 0]',[0 1 0]');   
        crv = nrbkntins(crv,eta_i);
      
        point_data = crv.coefs';                   
        for i = 1 : size(point_data, 1)
            point_node = DataNodeCreate('Point', CTPT_node, doc_handle);
            point_row_str = num2str(point_data(i, :));
            point_node.appendChild(doc_handle.createTextNode(point_row_str));
        end
        
        % /Unit/Patch/Order
        order_node = DataNodeCreate('Order', patch_node, doc_handle);
        order_str = num2str(crv.order-1);
        order_node.appendChild(doc_handle.createTextNode(order_str));
        
        % /Unit/Patch/Knot
        knot_node = DataNodeCreate('Knot', patch_node, doc_handle);
        
        % /Unit/Patch/Knot/Vector
        knot_data = {crv.knots};
        for i = 1 : size(knot_data, 1)
            vector_node = DataNodeCreate('Vector', knot_node, doc_handle);
            knot_row_str = num2str(knot_data{i});
            vector_node.appendChild(doc_handle.createTextNode(knot_row_str));
            vector_node.setAttribute('dof',num2str(length(knot_data{i})));
        end 
        
        % top boundary nurbs patch
        patch_node = DataNodeCreate('Patch', unit_node, doc_handle);
        patch_node.setAttribute('region','Boundary');
        patch_node.setAttribute('name','right');
        
        % /Unit/Patch/ControlPoint
        CTPT_node = DataNodeCreate('ControlPoint', patch_node, doc_handle);
        CTPT_node.setAttribute('dim','3');

        % /Unit/Patch/ControlPoint/Point
%         point_data = [1 0 0 1;
%                       1 1 0 1];
        crv = nrbline([1 0 0]',[1 1 0]');   
        crv = nrbkntins(crv,eta_i);
      
        point_data = crv.coefs';
        for i = 1 : size(point_data, 1)
            point_node = DataNodeCreate('Point', CTPT_node, doc_handle);
            point_row_str = num2str(point_data(i, :));
            point_node.appendChild(doc_handle.createTextNode(point_row_str));
        end
        
        % /Unit/Patch/Order
        order_node = DataNodeCreate('Order', patch_node, doc_handle);
        order_str = num2str(crv.order-1);
        order_node.appendChild(doc_handle.createTextNode(order_str));
        
        % /Unit/Patch/Knot
        knot_node = DataNodeCreate('Knot', patch_node, doc_handle);
        
        % /Unit/Patch/Knot/Vector
        knot_data = {crv.knots};
        for i = 1 : size(knot_data, 1)
            vector_node = DataNodeCreate('Vector', knot_node, doc_handle);
            knot_row_str = num2str(knot_data{i});
            vector_node.appendChild(doc_handle.createTextNode(knot_row_str));
            vector_node.setAttribute('dof',num2str(length(knot_data{i})));
        end 
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