
function logL = myLogLikeli2(params,y)


coeficient = y;

%obtian the number of chain
nchain = size(params,1);

%Loop to get the loglikelihood value of logL
logL=zeros(nchain,1);
%Loop to get every chain's logLikelihood sum error, 

% set cutoff on the bound on the delta
delta_Upbound = 15;
delta_lowerbound = -15;



for i1 = 1:nchain

    %This is a judgement to avoid the delta is loading beyond the beam,
    %pull the loading positon back

    if (params(i1,2) <= delta_lowerbound)
        params(i1,2) = delta_lowerbound;
    elseif (params(i1,2) >= delta_Upbound)
        params(i1,2) = delta_Upbound;
    end  
 
    
    logL(i1) = ErrorSum(params(i1,:),coeficient);



end

end


function Discrepancy = ErrorSum(params,coeficient)
        
        Discrepancy = 0;% set the initial vaule of discrepancy =0

        E = params(:,1);% Elastic modulus Prior (Pa)
 
        delta = params(:,2);% Loading position away from the middle point of beam, delta, Prior (m)  
        sigma2 = params(:,3);%discrepancy Prior

        


         %10 sets of measurements, %29 points along the beam

        % calculate the xi values:
        x_E = E/10e9;
        x_delta = delta/5;
        x = [x_E,x_delta];


        p =coeficient;
        model_fun_RSM = @(p,x)  p(1) + ...
                                p(2) * x(:,1) + ...
                                p(3) * x(:,2) + ...
                                p(4) * x(:,1).^2 + ...
                                p(5) * x(:,2).^2 + ...
                                p(6) * x(:,1).^3 + ...
                                p(7) * x(:,2).^3 + ...
                                p(8) * x(:,1).^4 + ...
                                p(9) * x(:,2).^4 + ...
                                p(10) * x(:,1).^3 .* x(:,2) + ...
                                p(11) * x(:,1).^2 .* x(:,2).^2 + ...
                                p(12) * x(:,1) .* x(:,2).^3 + ...
                                p(13) * x(:,1).^4 .* x(:,2) + ...
                                p(14) * x(:,1) .* x(:,2).^4 + ...
                                p(15) * x(:,1).^5 + ...
                                p(16) * x(:,2).^5 + ...
                                p(17) * x(:,1).^4 .* x(:,2).^2 + ...
                                p(18) * x(:,1).^3 .* x(:,2).^3 + ...
                                p(19) * x(:,1).^2 .* x(:,2).^4 + ...
                                p(20) * x(:,1) .* x(:,2).^5 + ...
                                p(21) * x(:,1).^6 + ...
                                p(22) * x(:,2).^6 + ...
                                p(23) * x(:,1).^5 .* x(:,2) + ...
                                p(24) * x(:,1).^4 .* x(:,2).^2 + ...
                                p(25) * x(:,1).^3 .* x(:,2).^3 + ...
                                p(26) * x(:,1).^2 .* x(:,2).^4 + ...
                                p(27) * x(:,1) .* x(:,2).^5 + ...
                                p(28) * x(:,1).^6 .* x(:,2) + ...
                                p(29) * x(:,1).^5 .* x(:,2).^2 + ...
                                p(30) * x(:,1).^4 .* x(:,2).^3 + ...
                                p(31) * x(:,1).^3 .* x(:,2).^4 + ...
                                p(32) * x(:,1).^2 .* x(:,2).^5 + ...
                                p(33) * x(:,1) .* x(:,2).^6;

        
        Y_forward = model_fun_RSM(p,x);




        %determinant of the variance
        Inv_var = inv(sigma2);
        logCdet = log(det(diag(ones(29,1)*sigma2)));		
        % calculate the Loglikelihood discrepancy
		Discrepancy = -0.5*logCdet  -  0.5*(Y_forward)*Inv_var*(Y_forward);
end 

