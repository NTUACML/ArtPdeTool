clear all; clc; home

filename = 'ArtPDE';

% create document
docNode = com.mathworks.xml.XMLUtils.createDocument('Geometry');

% document element
docRootNode = docNode.getDocumentElement();
docRootNode.setAttribute('format','FEM');

% Topology
topologyNode = docNode.createElement('Topology');
topologyNode.setAttribute('format','isoparametric');
docRootNode.appendChild(topologyNode);

% Point
pointNode = docNode.createElement('Point');
pointNode.appendChild(docNode.createTextNode('0.0 0.0 0.0'));
topologyNode.appendChild(pointNode);

pointNode = docNode.createElement('Point');
pointNode.appendChild(docNode.createTextNode('1.0 0.0 0.0'));
topologyNode.appendChild(pointNode);

pointNode = docNode.createElement('Point');
pointNode.appendChild(docNode.createTextNode('1.0 1.0 0.0'));
topologyNode.appendChild(pointNode);

pointNode = docNode.createElement('Point');
pointNode.appendChild(docNode.createTextNode('0.0 1.0 0.0'));
topologyNode.appendChild(pointNode);

% Property
propertyNode = docNode.createElement('Property');
propertyNode.setAttribute('name','Displacement');
topologyNode.appendChild(propertyNode);

% Vector
vectorNode = docNode.createElement('Vector');
vectorNode.setAttribute('dof','2');
vectorNode.appendChild(docNode.createTextNode('0.2 0.2'));
propertyNode.appendChild(vectorNode);

vectorNode = docNode.createElement('Vector');
vectorNode.setAttribute('dof','2');
vectorNode.appendChild(docNode.createTextNode('0.3 0.3'));
propertyNode.appendChild(vectorNode);

vectorNode = docNode.createElement('Vector');
vectorNode.setAttribute('dof','2');
vectorNode.appendChild(docNode.createTextNode('0.4 0.4'));
propertyNode.appendChild(vectorNode);

vectorNode = docNode.createElement('Vector');
vectorNode.setAttribute('dof','2');
vectorNode.appendChild(docNode.createTextNode('0.5 0.5'));
propertyNode.appendChild(vectorNode);

% Patch (Mesh, Domain)
patchNode = docNode.createElement('Patch');
patchNode.setAttribute('type','Mesh');
patchNode.setAttribute('region','Domain');
topologyNode.appendChild(patchNode);

% Element
elementNode = docNode.createElement('Element');
elementNode.appendChild(docNode.createTextNode('1 2 3 4'));
patchNode.appendChild(elementNode);

% Property
propertyNode = docNode.createElement('Property');
propertyNode.setAttribute('name','Density');
patchNode.appendChild(propertyNode);

% Scalar
scalarNode = docNode.createElement('Scalar');
scalarNode.appendChild(docNode.createTextNode('1'));
propertyNode.appendChild(scalarNode);

% Patch (Mesh, Boundary)
patchNode = docNode.createElement('Patch');
patchNode.setAttribute('type','Mesh');
patchNode.setAttribute('region','Boundary');
patchNode.setAttribute('name','Top');
topologyNode.appendChild(patchNode);

% Element
elementNode = docNode.createElement('Element');
elementNode.appendChild(docNode.createTextNode('3 4'));
patchNode.appendChild(elementNode);

% Property
propertyNode = docNode.createElement('Property');
propertyNode.setAttribute('name','Traction');
patchNode.appendChild(propertyNode);

vectorNode = docNode.createElement('Vector');
vectorNode.setAttribute('dof','2');
vectorNode.appendChild(docNode.createTextNode('0.0 1.0'));
propertyNode.appendChild(vectorNode);

% xmlwrite
xmlFileName = [filename,'.art_geometry'];
xmlwrite(xmlFileName,docNode);
type(xmlFileName);