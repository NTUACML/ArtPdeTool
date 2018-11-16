clear all; clc; home
%% Document setting
project_name = 'ArtPDE';
doc_format = 'FEM';
version = '1.0';

%% Document create
doc_geo = com.mathworks.xml.XMLUtils.createDocument('Geometry');
doc_init = com.mathworks.xml.XMLUtils.createDocument('Initial');
doc_mat = com.mathworks.xml.XMLUtils.createDocument('Material');

%% Document node
doc_geo_node = doc_geo.getDocumentElement();
doc_geo_node.setAttribute('format',doc_format);
doc_geo_node.setAttribute('version',version);

doc_init_node = doc_init.getDocumentElement();
doc_init_node.setAttribute('format',doc_format);
doc_init_node.setAttribute('version',version);

doc_mat_node = doc_mat.getDocumentElement();
doc_mat_node.setAttribute('format',doc_format);
doc_mat_node.setAttribute('version',version);

%% Data create (Geometry part)
doc_handle = doc_geo;

% /Unit
unit_node = DataNodeCreate('Unit', doc_geo_node, doc_handle);
unit_node.setAttribute('format','isoparametric');
unit_node.setAttribute('type','FEM');

% /Unit/Patch (Domain)
patch_node = DataNodeCreate('Patch', unit_node, doc_handle);
patch_node.setAttribute('region','Domain');
patch_node.setAttribute('name','domain_1');
patch_node.setAttribute('type','Solid');

% /Unit/Patch/Node
node_node = DataNodeCreate('Node', patch_node, doc_handle);
node_node.setAttribute('dim','3');

% /Unit/Patch/Node/Point
point_data = [0.0 0.0 0.0;
              1.0 0.0 0.0;
              1.0 1.0 0.0;
              0.0 1.0 0.0];
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
patch_node.setAttribute('type','Surface');

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