% function DemoFEM_XMLfile
clc; clear; close all;

%% Include package
import Geometry.*


%% Geometry data input
fem_geo = GeometryBuilder.create('FEM', 'XML', './XML_DataMaker/ArtPDE_FEM.art_geometry');



% end
