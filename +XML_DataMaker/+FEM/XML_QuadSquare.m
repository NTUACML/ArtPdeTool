clear all; clc; home
%% Mesh gen
[xn,idx,~,~,~,~,~,~,xb,neighbor_b,~] = rectanGeomMesh(11,11,0,1,0,1,1.0,1.0);
quadplot(idx, xn(:,1), xn(:,2), '-k')

eps = 1e-5;
ig_xn_down = abs(xn(:,2) - 0) < eps;
ig_xn_up = abs(xn(:,2) - 1) < eps;
ig_xn_left = abs(xn(:,1) - 0) < eps;
ig_xn_right = abs(xn(:,1) - 1) < eps;

ig_xb_down = abs(xb(:,2) - 0) < eps;
ig_xb_up = abs(xb(:,2) - 1) < eps;
ig_xb_left = abs(xb(:,1) - 0) < eps;
ig_xb_right = abs(xb(:,1) - 1) < eps;

bc_id_down = Quad4FindBC_ID(ig_xn_down, idx, neighbor_b(ig_xb_down));
bc_id_up = Quad4FindBC_ID(ig_xn_up, idx, neighbor_b(ig_xb_up));
bc_id_left = Quad4FindBC_ID(ig_xn_left, idx, neighbor_b(ig_xb_left));
bc_id_right = Quad4FindBC_ID(ig_xn_right, idx, neighbor_b(ig_xb_right));

% hold on
% for i = 1 : size(bc_id_left, 1)
%     plot(xn(bc_id_left{i,1}, 1), xn(bc_id_left{i,1}, 2), 'bo')
% end

%% Document setting
project_name = 'ArtPDE';
doc_format = 'FEM';
version = '1.1';
geo_dim = '2';

%% Document create
doc_geo = com.mathworks.xml.XMLUtils.createDocument('Geometry');
doc_init = com.mathworks.xml.XMLUtils.createDocument('Initial');
doc_mat = com.mathworks.xml.XMLUtils.createDocument('Material');

%% Document node
doc_geo_node = doc_geo.getDocumentElement();
doc_geo_node.setAttribute('version', version);
doc_geo_node.setAttribute('dim', geo_dim);

doc_init_node = doc_init.getDocumentElement();
doc_init_node.setAttribute('version',version);

doc_mat_node = doc_mat.getDocumentElement();
doc_mat_node.setAttribute('version',version);

%% Data create (Geometry part)
doc_handle = doc_geo;

% /Unit
unit_node = DataNodeCreate('Unit', doc_geo_node, doc_handle);
unit_node.setAttribute('format','FEM');

% /Unit/Patch (Domain)
patch_node = DataNodeCreate('Patch', unit_node, doc_handle);
patch_node.setAttribute('region','Domain');
patch_node.setAttribute('name','domain_1');

% /Unit/Patch/Node
node_node = DataNodeCreate('Node', patch_node, doc_handle);
node_node.setAttribute('dim','2');

% /Unit/Patch/Node/Point
% point_data = [xn, zeros(size(xn, 1), 1)];
point_data = xn;

for i = 1 : size(point_data, 1)
    point_node = DataNodeCreate('Point', node_node, doc_handle);
    point_row_str = num2str(point_data(i, :));
    point_node.appendChild(doc_handle.createTextNode(point_row_str));
end

% /Unit/Patch/Element
element_node = DataNodeCreate('Element', patch_node, doc_handle);

% /Unit/Patch/Element/Type
for i = 1 : size(idx, 1)
    type_node = DataNodeCreate('Type', element_node, doc_handle);
    connectivity = num2str(idx(i,:));
    element_type = 'Quad4';
    type_node.setAttribute('value',element_type);
    type_node.appendChild(doc_handle.createTextNode(connectivity));
end

% /Unit/Patch (Boundary - up)
patch_node = DataNodeCreate('Patch', unit_node, doc_handle);
patch_node.setAttribute('region','Boundary');
patch_node.setAttribute('name','up');

% /Unit/Patch/Element
element_node = DataNodeCreate('Element', patch_node, doc_handle);

% /Unit/Patch/Element/Type
bc_id = bc_id_up;
for i = 1 : size(bc_id, 1)
    type_node = DataNodeCreate('Type', element_node, doc_handle);
    connectivity = num2str(bc_id{i, 1});
    element_type = 'Line2';
    neighbor_element = num2str(bc_id{i, 2});
    type_node.setAttribute('value',element_type);
    type_node.setAttribute('neighbor',neighbor_element);
    type_node.appendChild(doc_handle.createTextNode(connectivity));
end

% /Unit/Patch (Boundary - down)
patch_node = DataNodeCreate('Patch', unit_node, doc_handle);
patch_node.setAttribute('region','Boundary');
patch_node.setAttribute('name','down');

% /Unit/Patch/Element
element_node = DataNodeCreate('Element', patch_node, doc_handle);

% /Unit/Patch/Element/Type
bc_id = bc_id_down;
for i = 1 : size(bc_id, 1)
    type_node = DataNodeCreate('Type', element_node, doc_handle);
    connectivity = num2str(bc_id{i, 1});
    element_type = 'Line2';
    neighbor_element = num2str(bc_id{i, 2});
    type_node.setAttribute('value',element_type);
    type_node.setAttribute('neighbor',neighbor_element);
    type_node.appendChild(doc_handle.createTextNode(connectivity));
end

% /Unit/Patch (Boundary - left)
patch_node = DataNodeCreate('Patch', unit_node, doc_handle);
patch_node.setAttribute('region','Boundary');
patch_node.setAttribute('name','left');

% /Unit/Patch/Element
element_node = DataNodeCreate('Element', patch_node, doc_handle);

% /Unit/Patch/Element/Type
bc_id = bc_id_left;
for i = 1 : size(bc_id, 1)
    type_node = DataNodeCreate('Type', element_node, doc_handle);
    connectivity = num2str(bc_id{i, 1});
    element_type = 'Line2';
    neighbor_element = num2str(bc_id{i, 2});
    type_node.setAttribute('value',element_type);
    type_node.setAttribute('neighbor',neighbor_element);
    type_node.appendChild(doc_handle.createTextNode(connectivity));
end

% /Unit/Patch (Boundary - right)
patch_node = DataNodeCreate('Patch', unit_node, doc_handle);
patch_node.setAttribute('region','Boundary');
patch_node.setAttribute('name','right');

% /Unit/Patch/Element
element_node = DataNodeCreate('Element', patch_node, doc_handle);

% /Unit/Patch/Element/Type
bc_id = bc_id_right;
for i = 1 : size(bc_id, 1)
    type_node = DataNodeCreate('Type', element_node, doc_handle);
    connectivity = num2str(bc_id{i, 1});
    element_type = 'Line2';
    neighbor_element = num2str(bc_id{i, 2});
    type_node.setAttribute('value',element_type);
    type_node.setAttribute('neighbor',neighbor_element);
    type_node.appendChild(doc_handle.createTextNode(connectivity));
end


% 
% % /Unit/Patch/ElementData
% element_data_node = DataNodeCreate('ElementData', patch_node, doc_handle);
% 
% % /Unit/Patch/ElementData/Data (Normal)
% data_node = DataNodeCreate('Data', element_data_node, doc_handle);
% data_node.setAttribute('name', 'Normal');
% 
% % /Unit/Patch/ElementData/Data/Vector
% normal = num2str([0 1 0]);
% vector_node = DataNodeCreate('Vector', data_node, doc_handle);
% vector_node.setAttribute('dof', '3');
% vector_node.appendChild(doc_handle.createTextNode(normal));


%% Document write
file_name_geo = [project_name, '_', doc_format ,'.art_geometry'];
xmlwrite(file_name_geo, doc_geo);

file_name_init = [project_name, '_', doc_format,'.art_initial'];
xmlwrite(file_name_init, doc_init);

file_name_mat = [project_name, '_', doc_format,'.art_material'];
xmlwrite(file_name_mat, doc_mat);

%% Using Function
function current_node = DataNodeCreate(name, upper_node, doc_handle)
    current_node = doc_handle.createElement(name);
    upper_node.appendChild(current_node);
end

function bc_id = Quad4FindBC_ID(xn_flag, idx, neighbor_b)
    num_xb = size(neighbor_b, 1);
    bc_id = cell(num_xb, 2);
    counter = 1;
    for i = 1 : num_xb
        id_23 = neighbor_b(i);
        for j = 1 : 4
            if(j ~= 4)
                xn_id_0 = idx(id_23, j);
                xn_id_1 = idx(id_23, j + 1);
            else
                xn_id_0 = idx(id_23, 4);
                xn_id_1 = idx(id_23, 1);
            end
            
            if(xn_flag(xn_id_0) && xn_flag(xn_id_1))
                bc_id{counter, 1} = [xn_id_0, xn_id_1];
                bc_id{counter, 2} = id_23;
                counter = counter + 1;
            end
        end
        
    end
end