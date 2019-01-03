function DemoIGA_Laplace3D
clc; clear; close all;

%% Include package
import Utility.BasicUtility.*
import Utility.NurbsUtility.*
import Geometry.*
import Domain.*
import Operation.*

%% Geometry data input
xml_path = './ArtPDE_IGA_3D_Lens_left.art_geometry';
geo = GeometryBuilder.create('IGA', 'XML', xml_path);
nurbs_topology = geo.topology_data_{1};

%% Domain create
iga_domain = DomainBuilder.create('IGA');

%% Basis create
nurbs_basis = iga_domain.generateBasis(nurbs_topology);

%% Nurbs tools create & plot nurbs
nurbs_tool = NurbsTools(nurbs_basis);

figure; hold on; grid on; view([140 30]); %axis equal; 
nurbs_tool.plotNurbs();
nurbs_tool.plotControlMesh();
hold off;
%% Variable define   
var_t = iga_domain.generateVariable('temperature', nurbs_basis,...
                                    VariableType.Scalar, 1);      
%% Test variable define
test_t = iga_domain.generateTestVariable(var_t, nurbs_basis);

%% Set domain mapping - > physical domain to parametric domain
iga_domain.setMapping(nurbs_basis);

%% Operation define (By User)
operation1 = Operation();
operation1.setOperator('grad_test_dot_grad_var');

%% Expression acquired
exp1 = operation1.getExpression('IGA', {test_t, var_t});

%% Integral variation equations
% Domain integral
doamin_patch = nurbs_topology.getDomainPatch();
iga_domain.calIntegral(doamin_patch, exp1);

%% Constraint (Acquire prescribed D.O.F.)


bdr_patch = nurbs_topology.getBoundayPatch('xi_1');
iga_domain.generateConstraint(bdr_patch, var_t, {1, @()0});

bdr_patch = nurbs_topology.getBoundayPatch('eta_0');
iga_domain.generateConstraint(bdr_patch, var_t, {1, @()0});

bdr_patch = nurbs_topology.getBoundayPatch('eta_1');
iga_domain.generateConstraint(bdr_patch, var_t, {1, @()0});

bdr_patch = nurbs_topology.getBoundayPatch('zeta_0');
iga_domain.generateConstraint(bdr_patch, var_t, {1, @()0});

bdr_patch = nurbs_topology.getBoundayPatch('zeta_1');
iga_domain.generateConstraint(bdr_patch, var_t, {1, @()0});

bdr_patch = nurbs_topology.getBoundayPatch('xi_0');
iga_domain.generateConstraint(bdr_patch, var_t, {1, @()1});

%% Solve domain equation system
iga_domain.solve('default');

%% Data Interpolation
import Interpolation.IGA.Interpolation;
t_interpo = Interpolation(var_t);

num_sample_pnt = [11 11 11];
[x, data, element] = t_interpo.DomainDataSampling(num_sample_pnt);

%% Show result through Paraview (Post-Processes)
import Utility.Resources.vtkwrite
import Utility.BasicUtility.TensorProduct

TP = TensorProduct(num2cell(num_sample_pnt));
xx = zeros(cell2mat(TP.num_));
yy = zeros(cell2mat(TP.num_));
zz = zeros(cell2mat(TP.num_));
tt = zeros(cell2mat(TP.num_));

for i = 1: TP.total_num_
    local_id = TP.to_local_index(i);
    xx(local_id{1}, local_id{2}, local_id{3}) = x(i, 1);
    yy(local_id{1}, local_id{2}, local_id{3}) = x(i, 2);
    zz(local_id{1}, local_id{2}, local_id{3}) = x(i, 3);
    tt(local_id{1}, local_id{2}, local_id{3}) = data(i);
end

vtkwrite('laplace_for_3d_lens.vtk', 'structured_grid', xx, yy, zz, 'scalars', 'temperature', data);
%% Show result
%disp(var_t);
end
