classdef HyperElasticityMooney < MaterialBank.MaterialBase 
    properties (Access = private)
        A10_
        A01_
        K_
        
        C_
        I1_
        I2_
        I3_
        
        J1E_
        J2E_
        J3E_
    end
    
    methods
        function this = HyperElasticityMooney(property)
           this@MaterialBank.MaterialBase();
           this.A10_ = property{1};
           this.A01_ = property{2};
           this.K_ = property{3};
           this.C_ = [];
        end
        
        function evaluate(this, F)
            X12 = 1/2; X13 = 1/3; X23 = 2/3; X43 = 4/3; X53 = 5/3; 
            
            this.C_ = F'*F;
            
            this.I1_ = trace(this.C_);
            this.I2_ = this.C_(1,1)*this.C_(2,2)+this.C_(1,1)*this.C_(3,3)+this.C_(2,2)*this.C_(3,3)-this.C_(1,2)^2-this.C_(2,3)^2-this.C_(1,3)^2;
            this.I3_ = det(this.C_);
            
            I1E = 2*[1 1 1 0 0 0]';
            I2E = 2*[this.C_(2,2)+this.C_(3,3), this.C_(3,3)+this.C_(1,1), this.C_(1,1)+this.C_(2,2), -this.C_(1,2), -this.C_(2,3), -this.C_(1,3)]';
            I3E = 2*[this.C_(2,2)*this.C_(3,3)-this.C_(2,3)^2,  this.C_(3,3)*this.C_(1,1)-this.C_(1,3)^2,  this.C_(1,1)*this.C_(2,2)-this.C_(1,2)^2, ...
                this.C_(2,3)*this.C_(1,3)-this.C_(3,3)*this.C_(1,2), this.C_(1,3)*this.C_(1,2)-this.C_(1,1)*this.C_(2,3), this.C_(1,2)*this.C_(2,3)-this.C_(2,2)*this.C_(1,3)]';
            
            W1 = this.I3_^(-X13); W2 = X13*this.I1_*this.I3_^(-X43); W3 = this.I3_^(-X23);
            W4 = X23*this.I2_*this.I3_^(-X53); W5 = X12*this.I3_^(-X12);
            
            this.J1E_ = W1*I1E - W2*I3E;
            this.J2E_ = W3*I2E - W4*I3E;
            this.J3E_ = W5*I3E;
        end
        
        function piola_stress = PiolaStress(this)           
            piola_stress = this.A10_*this.J1E_ + this.A01_*this.J2E_ + this.K_*(sqrt(this.I3_) - 1)*this.J3E_;
        end
        
        function D_matrix = materialMatrix(this)
            X12 = 1/2; X13 = 1/3; X23 = 2/3; X43 = 4/3; X53 = 5/3; X89 = 8/9;
            
            I2EE = [0  4  4  0  0  0; 4  0  4  0  0  0; 4  4  0  0  0  0;
                0  0  0 -2  0  0; 0  0  0  0 -2  0; 0  0  0  0  0 -2];
            I3EE = [ 0     4*this.C_(3,3)  4*this.C_(2,2)  0    -4*this.C_(2,3)  0;
                     4*this.C_(3,3)  0     4*this.C_(1,1)  0     0    -4*this.C_(1,3);
                     4*this.C_(2,2)  4*this.C_(1,1)  0    -4*this.C_(1,2)  0     0;
                     0     0    -4*this.C_(1,2) -2*this.C_(3,3)  2*this.C_(1,3)  2*this.C_(2,3);
                    -4*this.C_(2,3)  0     0     2*this.C_(1,3) -2*this.C_(1,1)  2*this.C_(1,2);
                     0    -4*this.C_(1,3)  0     2*this.C_(2,3)  2*this.C_(1,2) -2*this.C_(2,2)];
            
            W1 = X23*this.I3_^(-X12);    W2 = X89*this.I1_*this.I3_^(-X43); W3 = X13*this.I1_*this.I3_^(-X43);
            W4 = X43*this.I3_^(-X12);    W5 = X89*this.I2_*this.I3_^(-X53); W6 = this.I3_^(-X23);
            W7 = X23*this.I2_*this.I3_^(-X53); W8 = this.I3_^(-X12);        W9 = X12*this.I3_^(-X12);
            
            J1EE = -W1*(this.J1E_*this.J3E_' + this.J3E_*this.J1E_') + W2*(this.J3E_*this.J3E_') - W3*I3EE;
            J2EE = -W4*(this.J2E_*this.J3E_' + this.J3E_*this.J2E_') + W5*(this.J3E_*this.J3E_') + W6*I2EE - W7*I3EE;
            J3EE = -W8*(this.J3E_*this.J3E_') + W9*I3EE;
            
            D_matrix = this.A10_*J1EE + this.A01_*J2EE + this.K_*(this.J3E_*this.J3E_') + this.K_*(sqrt(this.I3_) - 1)*J3EE;
        end
    end
    
    
    
    
    
    
end

