function Y = plot_posterior(Posterior,gtarray,jj,myPriorDist)
%ADDME: Plot the all posterior figures at jj-th stage against prior
%       sampling. (also denote the mean and ground truth)
%       If jj <-- 1, plot the initial plotting against prior
%       If jj <--2, 3, 4,... plot the subsequet against posterior j-1

%Input: Posterior: Posterior at 1st-jjth stages
%       jj: jj-th stage
%       gtarray: ground truth array
%       myPriorDist: prior structure. only used for initial sampling,
%                    because since jj = 2, the prior is the posterior from 1st stage

%Output: 'Null': no output required


%No output required
Y = 'null';


%%
%choose which pattern to plot: initial plotting or subsequent posterior plotting
switch nargin 
    %initial plotting
    case 4    
        
        %get the number of inferred parameters of concerned 
        N_parameters = size(Posterior{jj},2);
        
        
        %extract all smaples from posterior (after 70% burn-in, the left samples) at jj-th stage
        Post_samples = cell2mat({Posterior{jj}(:).samples});
    

        %get the prior samples
        uq_selectInput(myPriorDist)%select input prior
        Prior_samples = uq_getSample(size(Post_samples,1),'LHS');
        Prior_samples = Prior_samples(:,1:N_parameters);

    %posterior plotting
    case 3

        
        %get the number of inferred parameters of concerned 
        N_parameters = size(Posterior{jj},2);
        
        
        %extract all smaples from jj-th and jj-1 posterior (after 70% burn-in, the left samples) at jj-th stage
        Post_samples = cell2mat({Posterior{jj}(:).samples});
        Prior_samples = cell2mat({Posterior{jj-1}(:).samples});
    
end

%% subplotting

    %extract all mean of the posterior at jj-th stage
    Mean_sample = cell2mat({Posterior{jj}(:).mv});

    %initialize counting plotting number
    N_plot = 0;


    % %calculate the 95% percentile
    % Post_Percentile_95 = prctile(Post_samples,95);
    % Post_Percentile_5 = prctile(Post_samples,5);
    % 
    % 
    % Post_samples_95 = 
       
    % for loop for subplot 
    for ii = 1:N_parameters % ii-th row
        for kk = 1: N_parameters % kk-th column
    
            if ii == kk % histogram plotting
                %create subplot empty space
                N_plot = N_plot +1;
                handle = subplot(N_parameters,N_parameters,N_plot);

                %histogram plotting
                histogram(Prior_samples(:,ii),'FaceColor','blue','FaceAlpha', 1);
                hold on;                    
                histogram(Post_samples(:,ii),'FaceColor','red','FaceAlpha', 1);
                % add ground truth
                h_gt = xline(gtarray(ii),'-k','LineWidth',1);
                hold off;
    
                % set limit for x-axis
                x_L_lim = min([Prior_samples(:,ii) Post_samples(:,ii)],[], 'all');
                x_U_lim = max([Prior_samples(:,ii) Post_samples(:,ii)],[], 'all');
                xlim([x_L_lim x_U_lim]);

                % add the variable names to the left the figure    
                if kk == 1
                    eval(['ylabel("X',num2str(ii) ,'",  "FontWeight","bold")']);
                end
                % add the variable names to the bottom of the figure
                if ii == N_parameters
                    eval(['xlabel("X',num2str(kk) ,'",  "FontWeight","bold")']);
                end
               
    
            else % scatter plotting 
                %create subplot empty space
                N_plot = N_plot +1;
                handle = subplot(N_parameters,N_parameters,N_plot); 

                %scatter plotting (including the ground truth and mean)
                h_prior = scatter(Prior_samples(:,kk),Prior_samples(:,ii),10,'MarkerFaceColor', ...
                        'blue','MarkerEdgeColor','white','MarkerFaceAlpha',.5,'LineWidth',1e-10);
                hold on;
                h_posterior = scatter(Post_samples(:,kk),Post_samples(:,ii),10,'MarkerFaceColor', ...
                        'red','MarkerEdgeColor','white','MarkerFaceAlpha',.5,'LineWidth',1e-10); 
                %h_gt = scatter(gtarray(kk),gtarray(ii),'green','LineWidth',0.3);% scatter ground truth
                xline(gtarray(kk),'-k','LineWidth',1);% scatter ground truth
                yline(gtarray(ii),'-k','LineWidth',1);% scatter ground truth

                %plot the envelopes for the scatter data
                
                xx = Post_samples(:,kk);
                yy = Post_samples(:,ii);
                index = convhull(xx,yy);
                plot(xx(index),yy(index));

                h_mv = scatter(Mean_sample(kk),Mean_sample(ii),'black','LineWidth',1.5);% scatter mean of the posterior
                hold off;
                box on;  

                % add limitation for x-axis and y-axis
                x_L_lim = min([Prior_samples(:,kk) Post_samples(:,kk)],[], 'all');
                x_U_lim = max([Prior_samples(:,kk) Post_samples(:,kk)],[], 'all');
                xlim([x_L_lim x_U_lim]);

                y_L_lim = min([Prior_samples(:,ii) Post_samples(:,ii)],[], 'all');
                y_U_lim = max([Prior_samples(:,ii) Post_samples(:,ii)],[], 'all');
                ylim([y_L_lim y_U_lim]);


                % add the variable names to the left the figure   
                if kk == 1
                    eval(['ylabel("X',num2str(ii) ,'",  "FontWeight","bold")'])
                end
                % add the variable names to the bottom of the figure
                if ii == N_parameters
                    eval(['xlabel("X',num2str(kk) ,'",  "FontWeight","bold")'])
                end 
                
                % we only need the low triangle subplot, make upper
                % triangle plots invisible
                if ii < kk
                    set(handle,'Visible','off');
                    set( get(handle,'Children'),'Visible','off');
                end



        
            end
    
        end
    end


    % legend for mean and ground truth 
    Lgnd = legend([h_gt h_mv h_prior h_posterior],{'Ground truth', 'Posterior mean', 'Prior samples','Posterior samples'},'FontSize',15) ;
    Lgnd.Position(1) = 0.5;
    Lgnd.Position(2) = 0.7;




end