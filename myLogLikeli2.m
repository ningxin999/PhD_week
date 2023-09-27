

function logL = myLogLikeli2(params,y)


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

        G01 = params(:,1);% G01
        G02 = params(:,2);% G02

        sigma2 = params(:,3);%discrepancy 

        X_val = [G01 G02];

        load('myPCE.mat');
        PCE =  uq_evalModel(myPCE,X_val);      
      
        N_diagonal = size(PCE,2);
        %determinant of the variance
        Inv_var = inv(diag(ones(1,N_diagonal)*sigma2));
        logCdet = log(det(diag(ones(N_diagonal,1)*sigma2)));		
        % calculate the Loglikelihood discrepancy
		Discrepancy = -0.5*logCdet  -  0.5*( y -PCE)*Inv_var*(y - PCE)';
end 


