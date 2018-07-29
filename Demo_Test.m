clc; clear; close all;

%% Include package
import Domain.*
import FunctionSpace.*

%% Domain
domain = DomainBuilder.create('Mesh', 'UnitCube');

%% Function Space
import Utility.BasicUtility.Order
function_space = FunctionSpaceBuilder.create('FEM', domain, {Order.Linear});