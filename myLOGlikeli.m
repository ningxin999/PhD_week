function logL = myLOGlikeli(params,y)

%obtian the number of chain
nchain = size(params,1);
%get the number of the experiment
nexp = size(y,1);

%Loop to get the loglikelihood value of logL
logL=zeros(nchain,1);
%Loop 1 to get every chain's logLikelihood sum error, Loop 2 is to get the sum 
%of the experiment discrepancy error 
for i1 = 1:nchain

    for i2 = 1:nexp
        
        logIntMC = ErrorSum(params(i1,:),y(i2,:));
        
        logL(i1) = logL(i1)+logIntMC;
        
    end
 
end

end


function Discrepancy = ErrorSum(params,Y)
        % set the initial vaule of discrepancy =0
        Discrepancy = 0;
        
        %put the forward model into the likelihood
        X(1) = 0.15;%constant b
        X(2) = 0.3;%constant h
        X(3) = 5;% constant L
        X(4) = params(:,1);% E which is the prior
        X(5) = params(:,2);% p which is the prior
        Y_forward = (5/32)*(X(:, 5).*X(:, 3).^4)./(X(:, 4).*X(:, 1).*X(:, 2).^3);
       %variance from params(:,3)
        sigma2 = params(:,3);

        %determinant of the variance

        logCdet = log(det(sigma2));
		
        % calculate the Loglikelihood discrepancy
		Discrepancy = -0.5*logCdet  -  0.5*((Y-Y_forward))*inv(sigma2)*((Y-Y_forward))' ;
end 

