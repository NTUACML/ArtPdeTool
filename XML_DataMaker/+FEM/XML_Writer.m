clear all; clc; home
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
node_node.setAttribute('dim','3');

% /Unit/Patch/Node/Point
L = 1;
D = 1;
t_1 = linspace(0, L, 4);
t_2 = linspace(-D/2, D/2, 4);
    
[t_2, t_1] = meshgrid(t_2, t_1);

point_data = [t_1(:), t_2(:), zeros(size(t_1(:))), ones(size(t_1(:)))];

for i = 1 : size(point_data, 1)
    point_node = DataNodeCreate('Point', node_node, doc_handle);
    point_row_str = num2str(point_data(i, :));
    point_node.appendChild(doc_handle.createTextNode(point_row_str));
end

% /Unit/Patch/Element
element_node = DataNodeCreate('Element', patch_node, doc_handle);

% /Unit/Patch/Element/Type
type_node = DataNodeCreate('Type', element_node, doc_handle);
connectivity = num2str([1 2 3 4]);
element_type = 'Quad4';
type_node.setAttribute('value',element_type);
type_node.appendChild(doc_handle.createTextNode(connectivity));

% /Unit/Patch (Boundary)
patch_node = DataNodeCreate('Patch', unit_node, doc_handle);
patch_node.setAttribute('region','Boundary');
patch_node.setAttribute('name','top');

% /Unit/Patch/Element
element_node = DataNodeCreate('Element', patch_node, doc_handle);

% /Unit/Patch/Element/Type
type_node = DataNodeCreate('Type', element_node, doc_handle);
connectivity = num2str([3 4]);
element_type = 'Line2';
neighbor_element = num2str(1);
type_node.setAttribute('value',element_type);
type_node.setAttribute('neighbor',neighbor_element);
type_node.appendChild(doc_handle.createTextNode(connectivity));

% /Unit/Patch/ElementData
element_data_node = DataNodeCreate('ElementData', patch_node, doc_handle);

% /Unit/Patch/ElementData/Data (Normal)
data_node = DataNodeCreate('Data', element_data_node, doc_handle);
data_node.setAttribute('name', 'Normal');

% /Unit/Patch/ElementData/Data/Vector
normal = num2str([0 1 0]);
vector_node = DataNodeCreate('Vector', data_node, doc_handle);
vector_node.setAttribute('dof', '3');
vector_node.appendChild(doc_handle.createTextNode(normal));


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