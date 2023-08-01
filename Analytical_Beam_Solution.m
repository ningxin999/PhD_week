
function ResidualSum = Analytical_Beam_Solution(X)

        % Input X dimension = Nsample X 2
        E = X(:,1); % dimension  = Nsample X 1
        delta = X(:,2); % dimension = Nsample X 1


        %Generate a synthetic ground truth without noise
        %Ground truth: ;  N is the number of experiment expNum; noisePercentage = 0%
        E_true = 25e9;
        delta_true = -3;    
        noisePercentage_true = 0.03;
        Measurement = Deflection(E_true,delta_true,noisePercentage_true);


        % FE realization    

        FE_Realization = Deflection(E,delta,0);
        
        
        
        %%calculate the  Residual for the surrogate   

        expNum = size(Measurement,1);% experiment number  N

        Npoint = size(Measurement,2);% number of z [z1,z2,...,z28,z29]

        Residual = []; % intitail value for Residual
        ResidualSum = [];% intitail value for ResidualSum

        %loop to calculate the ResidualSum 


        error= ((Measurement(1,:) - FE_Realization) ).^2;
        %error= abs((Measurement(1,:) - FE_Realization) );
        Residual(:,1) = sum(error,2);


        %Divide the number of experiment expNum  and monitored points number along
        %the beam Npoint = 29
        ResidualSum(:,1) = sum(Residual(:,1),2)/expNum/Npoint;
          

end 



