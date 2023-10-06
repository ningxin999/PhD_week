

function logL = myLogLikeli_F(params,y)

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

        E = params(:,1);% E
        delta = params(:,2);% delta
        F = params(:,3);% Loading force (N)

        sigma2 = params(:,4);%discrepancy Prior
        X_val = [E delta F];


        load('myPCE.mat');
        load('S.mat');
        load('V.mat');
        load('number.mat');
        load('st.mat');
        load('mv.mat');
        PCA_PCE =  uq_evalModel(myPCE,X_val);   


        YPCE= uq_evalModel(myPCE,X_val);
        YPCE = YPCE * V(:, 1:number)';
        for i = 1:size(YPCE, 2)
            YPCE(:, i) = YPCE(:, i) * st(i) + mv(i);
        end
              
        N_diagonal = size(YPCE,2);
        %determinant of the variance
        Inv_var = inv(diag(ones(1,N_diagonal)*sigma2));
        logCdet = log(det(diag(ones(N_diagonal,1)*sigma2)));		
        % calculate the Loglikelihood discrepancy

		Discrepancy = -0.5*logCdet  -  0.5*( y -YPCE)*Inv_var*(y - YPCE)';
end 


