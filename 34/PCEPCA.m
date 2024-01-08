function [myPCE, PCA]  = PCEPCA(AnParam, experimentaldesign, FEoutput, Stage, dispvalidation)
  %ADDME: PCEPCA structure to   generate  surrogate

  %Input:   AnParam-Analysis structure with parameters
  %         experimentaldesign-80% to construct surrogate; 20% to validate
  %         FEoutput-FE output
  %         Stage-i-th stage number
  %         dispvalidation-display validation figure


  %Output: PCA and PCE structure




%Define a cell PCA；each observation is created as a structure. 
    for jj = 1:AnParam.N_outputfields                                          
        PCA{jj}.minimumPC   = 1;                % Minimum number of principal components
        %PCA{jj}.st          = 'null';           % Standard deviation of FE_output (to decenter data)
        PCA{jj}.mv          = 'null';           % Mean of FE_output (to decenter data)
        PCA{jj}.V           = 'null';           % Sorted array of eigenvector matrix
        PCA{jj}.E           = 'null';           % Eigenvalue vector
        PCA{jj}.cumE        = 'null';           % Cumulative explanation
        PCA{jj}.number      = 'null';           % Number of principal components
        PCA{jj}.offset      = jj;               % Discrepancy number offset. Used in LL function.
        PCA{jj}.validation_PCA_PCE = 'null';    % Allocation for validation array.
        PCA{jj}.dataprocess = 'null';    % Allocation for validation array.



        % Create UQ input model     
            for ii = 1: AnParam.N_parameters
                InputOpts_D.Marginals(ii).Type = 'Uniform';                       % Uninformed prior (uniform)
                InputOpts_D.Marginals(ii).Parameters  = [min(experimentaldesign(:,ii)) ... % min(ED{col{i}}
                                                         max(experimentaldesign(:,ii)) ];  % max(ED{col{i}})
            end
        
            myInput = uq_createInput(InputOpts_D);     

        %Training data number and test data number

            N_train = floor(AnParam.TrainDataPerc*AnParam.N_RUN);

    
        % Calculate PCA using FE output data. (20% left for validation)
            %PCA{jj}=evalPCA(PCA{jj}, FEoutput{jj}(:,Stage), 0.99999999999999); 
            PCA{jj}=evalPCA(PCA{jj}, FEoutput{jj}{:,Stage}(1:N_train,:), 0.999999999999); 

        
        % Construct surrogate model
            metaopts.Type = 'Metamodel';
            metaopts.MetaType = 'PCE';
            metaopts.Method = 'LARS';
            metaopts.TruncOptions.qNorm = 0.75;
            metaopts.Degree = 2:15;
            %Y = PCA{jj}.dataprocess *  PCA{jj}.V(:, 1:PCA{jj}.number);     % project original data into PCs space
            Y = PCA{jj}.score(:, 1:PCA{jj}.number);     % project original data into PCs space
            metaopts.ExpDesign.X = experimentaldesign(1:N_train,:);       % Experimental design input draws
            metaopts.ExpDesign.Y = Y;               % PCE on principle component of Y outputs (not on Y outputs)
            myPCE{jj} = uq_createModel(metaopts);



%plotting PCA-PCE validation set if necessary
        if dispvalidation == true
            % Global sensitivity analysis (Sobol's indices)
                SobolOpts.Type = 'Sensitivity';
                SobolOpts.Method = 'Sobol';
                SobolOpts.Sobol.Order = 1;
                mySobolAnalysisPCE = uq_createAnalysis(SobolOpts);  
                uq_print(mySobolAnalysisPCE);

            %% Obtain the principle components of Y output
                PCA{jj}.validation_PCA_PCE = uq_evalModel(myPCE{jj},experimentaldesign(N_train+1:end,:));

            %% Reconstruct the output        
                YPCE{jj} = PCA{jj}.validation_PCA_PCE * PCA{jj}.V(:, 1:PCA{jj}.number)' + PCA{jj}.mv;


            % True vs predicted plot (Note: plot on the full order Y output, not on the PCs)
                uq_figure;
                hold on;
                uq_plot([0.9*min(YPCE{jj},[],'all') 1.1*max(YPCE{jj},[],'all')], [0.9*min(YPCE{jj},[],'all') 1.1*max(YPCE{jj},[],'all')], 'k');
                axis equal;
                axis([[0.9*min(YPCE{jj},[],'all') 1.1*max(YPCE{jj},[],'all')], [0.9*min(YPCE{jj},[],'all') 1.1*max(YPCE{jj},[],'all')]]);
                uq_plot(FEoutput{jj}{:,Stage}(N_train+1:end,:), YPCE{jj}, '+');
                xlabel('Yval');
                ylabel('YPCE');
                box on;
                hold off;   
        end


    end
end    


function PCA = evalPCA(PCA, FE_output, explainedvariance_threshold)  
% ADDME  Calculates PCA based on an array of FE output to a minimum explained vairance.
%
% Inputs:  
% PCA structures for an observation field                             (structure)
% Array of doubles containing FE output. m runs; n number of outputs  (array of double) 
% Percentage variance explained by PCA components                     (1x1 double)  
% 
% Output:
% Modified PCA structure                                              (structure)
%
% 
        if ~iscell(FE_output)
            [m,n]   = size(FE_output);                            % Calculate the rows and coloums of FE_output
        else
            FE_output = FE_output{1};
            [m,n]   = size(FE_output);
        end

    %-------------Step 1: Calculate the mean and standard deviation of raw data FE_output-----------------%
	    %[NormalizedFE_output,PCA.mv,PCA.st] = zscore(FE_output);%Normalilzed,meanand and standard deviation of the raw data
	
    %-------------Step 2: do PCA -----------------% 
	    %%%%%% Note: pca build-in function in matlab doesnot require normalization

        %PCA.V : V stands for eigen vector (eigen vector means new axis to be projected)
        %PCA.S : S stands for score (score means PCs in new coordinates),
                 %not required
        %latent: absolute variance contribution for every PC in full PCs space, can be
        %        converted to PCA.E
        %PCA.E: explain contribution percentage in PC space, sum(PCA.E) is 100
        %PCA.cumE: cumulative explain contribution in PC space
        
        PCA.dataprocess = FE_output;
        [PCA.V,PCA.score,latent,~,PCA.E,PCA.mv] = pca(FE_output,'Economy',false);
           

    %-------------Step 3: calculate the cumulative contribution  -----------------% 

        tep         = PCA.E./sum(PCA.E);% normalized the contribution percentage
        PCA.cumE    = cumsum(tep);      % calculate the cumulative contribution percentage
        PCA.number  = find(PCA.cumE>explainedvariance_threshold,1);% find the minimum PCs number required
	    
    %------------- Step 4: Set a minimum PC components (in case minimumPC is not a number) -----------------%
        if PCA.number < PCA.minimumPC
            PCA.number = PCA.minimumPC;
        end	
	

end