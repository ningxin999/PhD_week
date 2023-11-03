

function logL = LL2(params,y)

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
        sigma2_2= params(:,2);%discrepancy variance 



%Evalution of YPCE
        X = [E];

        Y = Beam_elongation(X);




% Get the Discrepancy1      
         N_diagonal = size(Y,2);

         D = eye(N_diagonal)*sqrt(sigma2_2);
         R = 1; %correlated coefficient
         C = D*R*D;

         L = chol(C,'lower');

         Linv = inv(L);


        Cinv = Linv'*Linv;
        logCdet = 2*trace(log(L));


        Discrepancy = -0.5*logCdet  -  1/2*( y -Y)*Cinv*( y -Y)';
 
        % disp(Discrepancy)
        % disp('++++++')

end 

