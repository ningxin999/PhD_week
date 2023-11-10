

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

global S V number st mv myPCE

% Initialization
        E = params(:,1);% E
        delta = -3;% delta
        F = params(:,2);% F
        sigma2 = params(:,3);%discrepancy variance 


%Evalution of YPCE
        X_val = [E delta F];

        %make prediction YPCE for PCs 
        PCA_PCE =  uq_evalModel(myPCE,X_val);



        %change PCs into true deflection of beam points
        YPCE = PCA_PCE * V(:, 1:number)';

        for i = 1:size(YPCE, 2)
            YPCE(:, i) = YPCE(:, i) * st(i) + mv(i);
        end



% Get the covariance matrix        
         N_diagonal = size(YPCE,2);

         D = eye(N_diagonal)*sqrt(sigma2);
         R = 1; %correlated coefficient
         C = D*R*D;

         L = chol(C,'lower');

         Linv = inv(L);


        Cinv = Linv'*Linv;
        logCdet = 2*trace(log(L));


        Discrepancy =-0.5*logCdet  -  1/2*( y -YPCE)*Cinv*( y -YPCE)';


end 


