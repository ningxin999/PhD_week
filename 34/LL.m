function logL = LL(params, y, PCA, myPCE, n, position)
% Inputs:  
% params: an array of MCMC evaluation                                    (array of doubles)
% y: matrix of observation data                                          (array of doubles)
% PCA: structures for an observation field                               (structure)
% myPCE: custom PCE class created by UQLab                               (custom class uq_model)
% n: AnParam.N_parameters                                              (integer)
% position: sigma2 colm position within the params array                 (integer)

    %Loop to get the loglikelihood value of logL
    logL=zeros(size(params,1),1);
    %Loop 1 to get every chain's logLikelihood sum error, Loop 2 is to get the sum 
    %of the experiment discrepancy error 
    for ii = 1:size(params,1)
        % Loop  to get the sum of logL
        for jj = 1:size(y,1)
            Incre_logli =  ErrorSum(params(ii,:), y(jj,:), PCA, myPCE, n, position);
            logL(ii) = logL(ii) + Incre_logli;
        end
    end
end


function Discrepancy = ErrorSum(params,y, PCA, myPCE, n, position)

% Initialization
        X_val  = params(:,1:n);
        
        % ======
        % TODO
        % This section of code needs a bit more work. This method works
        % perfectly well when we have a consistent number of field
        % measurements. However, once you start having a large number of
        % asynchronous field observations that you are back-analysis the
        % code doesnt work as well.  
            sigma2 = params(:,n+position);
        % ======

        %Evalution of YPCE
        % make prediction YPCE for PCs 
        PCA_PCE =  uq_evalModel(myPCE,X_val);

        % reconstruct the output        
        YPCE = PCA_PCE * PCA.V(:, 1:PCA.number)' + PCA.mv;
        % % De-normalize the score for each principal component
        % for ii = 1:size(YPCE, 2)
        %     YPCE(:, ii) = YPCE(:, ii) * PCA.st(:, ii) + PCA.mv(:, ii);
        % end

% Get the covariance matrix        
         N_diagonal = size(YPCE,2);
         D = eye(N_diagonal)*sqrt(sigma2);
         R = 1; %correlated coefficient
         C = abs(D*R*D);
         L = chol(C,'lower');
         Linv = inv(L);
         Cinv = Linv'*Linv;
         logCdet = 2*trace(log(L));

         Discrepancy = -0.5 * logCdet - 1/2*(y -YPCE)*Cinv*(y -YPCE)';
end 


