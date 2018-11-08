classdef Assembler < Assembler.AssemblerBase
    %ASSEMBLER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function this = Assembler(dof_manager)
            this@Assembler.AssemblerBase(dof_manager);
        end
        
        function status = Assembly(this, type, var, basis_id, data)
            import Utility.BasicUtility.AssemblyType
            if(type == AssemblyType.Matrix)
                status = this.IGA_LHS_Assembly(var, basis_id, data);
            elseif(type == AssemblyType.Vector)
                status = this.IGA_RHS_Assembly(var, basis_id, data);
            elseif(type == AssemblyType.Constraint)
                status = this.IGA_Constraint_Assembly(var, basis_id, data);
            else
                disp('Error <IGA Assembler>! - Assembly!');
                disp('> your assembly type error, please check!');
                status = false;
            end
        end
    end
    
    methods(Access = private)
        function status = IGA_LHS_Assembly(this, var, basis_id, data)
            if(length(var) == 2 && length(basis_id) == 2)
                test = var{1};
                var = var{2};
                
                row_id = this.dof_manager_.getAssemblyId(test.variable_data_, basis_id{1});
                col_id = this.dof_manager_.getAssemblyId(var, basis_id{2});
                
                this.lhs_(row_id, col_id) = this.lhs_(row_id, col_id) + data;
                status = true;
            else
                disp('Error <IGA Assembler>! - FEM_LHS_Assembly!');
                disp('> LHS assemly error, please check!');
                status = false;
            end
        end
        
        function status = IGA_RHS_Assembly(this, var, basis_id, data)
            status = false;
        end
        
        function status = IGA_Constraint_Assembly(this, var, basis_id, data)
            if(size(data, 2) == 2)
                dof_id = data(:,1);
                const_value = data(:,2);
                row_id = this.dof_manager_.getAssemblyId_by_DofId(var, basis_id, dof_id);
                % erase lhs row value
                this.lhs_(row_id, :) = 0;
                % put constraint value
                for i = 1:length(basis_id)
                    this.lhs_(row_id(i), row_id(i)) = 1;
                    this.rhs_(row_id(i)) = const_value(i);
                end
                status = true;
            else
                disp('Error <IGA Assembler>! - FEM_Constraint_Assembly!');
                disp('> Constraint data format error, please check!');
                status = false;
            end
        end
    end
end

