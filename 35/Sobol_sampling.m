function EDarray = Sobol_sampling(ED,AnParam,jj,Posterior)

%ADDME: enrich for the EoD sampling 
%Input: ED-Probabilistic ED input
%       AnParam strcuture
%       jj- jj-th loading/construction stage 
%       Posterior-posterior results from last stage (if it exists)

%Output: EDarray-enriched EDarray



% find the subfolder 'EoD_FE_summary'
%get the *.mat file from subfolder
subfolder = [pwd() '\output\mat\EoD_FE_summary'];    
files = dir(fullfile(subfolder, '*.mat'));

%choose right case: 
switch nargin

    %%if this is only enriching EoD for the fisrt stage, no posterior exist
    case 2  
            %%% Create the initial myPriorDist object for experimental of design
                myPriorDist_ED = [];%create a initial myPriorDist_ED
                PriorOpts_EoD = datainput(ED); 
                %PriorOpts_EoD.Name = 'Prior for EoD';
                myPriorDist_ED = uq_createInput(PriorOpts_EoD);

        
            %If there is existed FE results before, extract previous ED 
            % and enrich based on Sobol; if there is no FE results
            % available, create new Sobol samples
            %Seed here is to ensure function uq_getSample doesnot change 
            %the seed we set before in the loop

                rng(AnParam.EoDseed,'twister');
                if isempty(files) == 1 
                    % no existed FE results before
                    uq_selectInput(myPriorDist_ED)%select input prior
                    EDarray = uq_getSample(AnParam.N_RUN_EoD,'LHS');
                else        
                    %there existed FE results
                    %for loop to vertcat FE results and EoD array
                    ED_previous = [];
                    for kk = 1:numel(files)
                        load([subfolder '\' files(kk).name]);                
                        ED_previous = vertcat(ED_previous,EDarray);
                    end
                
                    EDarray = uq_LHSify(ED_previous,AnParam.N_RUN_EoD,myPriorDist_ED);
                end

   


    % if there is a posterior sampling from last stage and we hopt to
    % enrich the sample base on the posterior
    case 4           
            %%% Create the initial myPriorDist object for experimental of design
                myPriorDist_ED = [];%create a initial myPriorDist_ED
                PriorOpts_EoD = datainput(ED); 
                %PriorOpts_EoD.Name = 'Prior for EoD';
                %Add boundary for the enriched sobol samples
                for ii = 1:AnParam.N_parameters  
                    PriorOpts_EoD.Marginals(ii).Bounds = [Posterior{jj-1}(ii).LB Posterior{jj-1}(ii).UB];
                end
                myPriorDist_ED = uq_createInput(PriorOpts_EoD);

            %Previous FE results must exist if posterior exists
            %for loop to vertcat FE results and EoD array
                ED_previous = [];
                for kk = 1:numel(files)
                    load([subfolder '\' files(kk).name]);                
                    ED_previous = vertcat(ED_previous,EDarray);
                end
        
            EDarray = uq_enrichSobol(ED_previous,AnParam.N_RUN_EoD,myPriorDist_ED);
end