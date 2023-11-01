

function logL = LL1(params,y)



%obtian the number of chain
nchain = size(params,1);
%get the number of the experiment
nexp = size(y,1);

%Loop to get the loglikelihood value of logL
logL=zeros(nchain,1);
%Loop 1 to get every chain's logLikelihood sum error, Loop 2 is to get the sum 
%of the experiment discrepancy error 


    for i1 = 1:nchain
    
    
        % Loop  to get the sum of logL
        for i2 = 1:nexp
    
            Incre_logli =  ErrorSum(params(i1,:),y(i2,:));
            
            logL(i1) = logL(i1) + Incre_logli;
 

       
        end
    
    end

end


function Discrepancy = ErrorSum(params,y)


% Initialization
        E = params(:,1);% E
        F = params(:,2);% F
        sigma2_1 = params(:,4);%discrepancy variance 


%Evalution 
        X_val = [E  F];

        Y = uq_SimplySupportedBeam(X_val);






% Get the covariance matrix        
         N_diagonal = size(Y,2);

         D = eye(N_diagonal)*sqrt(sigma2_1);
         R = 1; %correlated coefficient
         C = D*R*D;

         L = chol(C,'lower');

         Linv = inv(L);


        Cinv = Linv'*Linv;
        logCdet = 2*trace(log(L));


        Discrepancy = -0.5*logCdet  -  1/2*( y -Y)*Cinv*( y -Y)';


end 


