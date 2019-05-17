classdef SaintVenantKirchhoff < MaterialBank.MaterialBase 
    properties (Access = private)
        nu_
        E_
        
        lambda_
        mu_
        
        C_
    end
    
    methods
        function this = SaintVenantKirchhoff(property)
           this@MaterialBank.MaterialBase();
           this.nu_ = property{1};
           this.E_ = property{2};
           this.C_ = [];
        end
        
        function evaluate(this, F)         
            this.C_ = F'*F;
            
            this.lambda_ = this.E_ * this.nu_ / (1+this.nu_) / (1-2*this.nu_);
            this.mu_ = this.E_ / 2 / (1+this.nu_);         
        end
        
        function piola_stress = PiolaStress(this)               
            green_strain = 0.5*(this.C_ - eye(3));
            S = this.lambda_* trace(green_strain)*eye(3) + 2*this.mu_*green_strain;
            piola_stress = [S(1,1); S(2,2); S(3,3); S(1,2); S(2,3); S(1,3)];
        end
        
        function D_matrix = materialMatrix(this)          
            D_matrix = zeros(6,6);
            D_matrix(1:3, 1:3) = this.lambda_;
            
            D_matrix(1,1) = D_matrix(1,1) + 2*this.mu_;
            D_matrix(2,2) = D_matrix(2,2) + 2*this.mu_;
            D_matrix(3,3) = D_matrix(3,3) + 2*this.mu_;
            D_matrix(4,4) = this.mu_;
            D_matrix(5,5) = this.mu_;
            D_matrix(6,6) = this.mu_;          
        end
    end
    
    
    
    
    
    
end

