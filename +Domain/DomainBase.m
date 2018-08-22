classdef DomainBase < handle
    %DOMAINBASE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        variable_
        approximated_geo_
        integral_geo_
        interior_domain_
        num_boundary_domain_ = 0
        boundary_domain_
    end
    
    methods
        function this = DomainBase(variable)
            this.variable_ = variable;
        end
        
        function setApproximatedGeometry(this, approximated_geo)
            if(isa(approximated_geo, 'Geometry.Geometry'))
                this.approximated_geo_ = approximated_geo;
            else
                disp('Error <DomainBase>! check approximated geometry input type!');
                disp('> empty approximated geometry builded!');
            end
        end
        
        function setIntegralGeometry(this, integral_geo)
            if(isa(integral_geo, 'Geometry.Geometry'))
                this.integral_geo_ = integral_geo;
            else
                disp('Error <DomainBase>! check integral geometry input type!');
                disp('> empty integral geometry builded!');
            end
        end
    end
    
    methods (Access = protected)
        function generateVariableData(this)
            if(~isempty(this.approximated_geo_))
                num_dof = this.variable_.num_dof_;
                num_data = this.approximated_geo_.num_point_;
                % set variable data number
                this.variable_.num_data_ = num_data;
                % set temporary data
                tmp_data = zeros(num_data, 1);
                % set data into variable
                for i = 1 : num_dof
                    this.variable_.dof_data_{i} = tmp_data;
                end
            else
                disp('Error <DomainBase>!');
                disp('> check approximated geometry setted up properly!');
            end
        end
    end
    
end

