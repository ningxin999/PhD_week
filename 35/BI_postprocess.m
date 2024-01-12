function Posterior = BI_postprocess(jj,BayesAnalysis,AnParam,Posterior,gtarray,myPriorDist)
%ADDME: Burn in 70% and extract posterior samples for data preparation 
%       for next stage priors


%Input: 
%       jj-the jj-th number of stage jj <----1,2,...,AnParam.N_stage
%       AnParam-structure of analysis parameters
%       BayesAnalysis-result strcuture, all posterior information is stored in this.
%       gtarray: known ground truth parameters



%Output:Posterior structure


% Burn in 70% 
    uq_postProcessInversionMCMC(BayesAnalysis,'pointEstimate','MAP', ...
                                'percentiles',[0.05,0.95],'burnin',0.7);
    
    disp(['Printing analysis for Stage ' {jj}])
    %uq_print(BayesAnalysis); 
    %uq_display(BayesAnalysis);
    
% Extract samples from the posterior and reshape into a vector
    for ll = 1: AnParam.N_parameters                
        temp =  BayesAnalysis.Results.PostProc.PostSample(:,ll,:);
        Posterior{jj}(ll).samples = reshape(permute(temp, [2 1 3]), size(temp, 2), [])';
        Posterior{jj}(ll).mv = BayesAnalysis.Results.PostProc.Percentiles.Mean(:,ll);
        Posterior{jj}(ll).st = BayesAnalysis.Results.PostProc.Percentiles.Var(:,ll)^0.5;
        Posterior{jj}(ll).LB = BayesAnalysis.Results.PostProc.Percentiles.Values(1,ll);
        Posterior{jj}(ll).UB = BayesAnalysis.Results.PostProc.Percentiles.Values(2,ll);
    end   

%plot the posterior against prior 
    if jj ==1
        [~] = plot_posterior(Posterior,gtarray,jj,myPriorDist);
    else 
        [~] = plot_posterior(Posterior,gtarray,jj);
    end
    
end

