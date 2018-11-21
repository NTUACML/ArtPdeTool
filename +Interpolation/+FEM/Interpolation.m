classdef Interpolation < Interpolation.InterpolationBase
    %INTERPOLATION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        interpo_topo_
    end
    
    methods
        function this = Interpolation(variable)
            this@Interpolation.InterpolationBase();
            if(isa(variable, 'Variable.Variable'))
                this.interpo_data_ = variable;
                this.interpo_basis_ = variable.basis_data_;
                this.interpo_topo_ = this.interpo_basis_.topology_data_;
            else
                disp('Error <Interpolation = FEM>! ');
                disp('> The input type should be a variable!');
            end
        end
        
        function [x, data, element] = NodeDataInterpolation(this)
            x = this.interpo_topo_.point_data_(:,:);
            data = this.interpo_data_.getVarData();
            element = this.interpo_topo_.getDomainPatch().element_data_;
        end
    end
    
end

