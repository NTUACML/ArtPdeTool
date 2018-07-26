clc; clear; close all;

%% Include package
import Domain.*

domain = DomainBuilder.create('Mesh', 'UnitCube');
disp(domain)