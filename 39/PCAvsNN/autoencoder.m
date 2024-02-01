Autoencoder (P X N)
Zscore the data (required)
    
    [Zscore_Y_GT,mu,std] = zscore(Y_GT');
    %Zscore_Y_GT = rescale(Zscore_Y_GT,-1,1);
    Zscore_Y_GT = normalize(Zscore_Y_GT);
Autoencoder ()
    autoenc = trainAutoencoder(Zscore_Y_GT,50,...
            'maxEpochs',1000,...
            'EncoderTransferFunction','satlin',...
            'DecoderTransferFunction','purelin',...
            'L2WeightRegularization',4e-3,...
            'SparsityRegularization',4,...
            'SparsityProportion',0.15,...
            'ScaleData',false);


        %autoenc = trainAutoencoder(Zscore_Y_GT,N_PC);


    %AE_PCs = encode(autoenc,Zscore_Y_GT);
    %AE_reconstruct = decode(autoenc,AE_PCs);% reconstruct

    AE_reconstruct = predict(autoenc,Zscore_Y_GT);
    %AE_reconstruct = AE_reconstruct .*std + mu;
    

%AE reconstruction error

    [~] = recontruction_plot(Zscore_Y_GT,AE_reconstruct,'Y_GT','Y_{AE_reconstruct}','AE reconstruction error');



MSE error
    mseError_2 = mse((Y_GT'-AE_reconstruct))
Autoencoder error covariance
    %[~] = covariance_plot(Y_GT_AE,AE_reconstruct);
Cross validation

% %AE analysis  
% %Zscore the data (required) and autoencoder 
% 
%     train_x_AE = train_x';
%     [Zscore_train, Zscore_mu_train,Zscore_std_train] = zscore(train_x_AE);
%     Zscore_train = Zscore_train';% transpose the dimension as P X N
%     autoenc = trainAutoencoder(Zscore_train,100);
% 
%     Zscore_test = (test_x - Zscore_mu_train) ./Zscore_std_train;
%     Zscore_test = Zscore_test';% transpose the dimension as P X N
% 
% 
% %reconstruct the data  using test 
% 
%     AE_PCs = encode(autoenc,Zscore_test)';% projection into latent reduced space
%     AE_reconstruct = decode(autoenc,AE_PCs');% reconstruct
%     AE_reconstruct = AE_reconstruct'.*Zscore_std_train + Zscore_mu_train;
% 
% 
% %plot cross validation
%     %[~] = recontruction_plot(test_x,AE_reconstruct,'Y_{Reconstruc_train}','Y_{test_x}','AE cross-validation error');
% 
% %mse percentage error
%     %mseError_test = mse((test_x-AE_reconstruct)./test_x)





PCA-Cross validation
%     N_train = round(0.8*n);
%     train_x = Y_GT(1:N_train,:);
%     test_x = Y_GT(N_train +1:end,:);
% 
% 
% %PCA analysis   
%    [coeff_1,score_1,latent_1,~,explained_1,mu_1] = pca(train_x,'Economy',false);
% 
% 
% %select the numbers of  PCs
%     test_center = test_x -mu_1;
%     test_PCA = test_center*coeff_1(:,1:N_PC);
% 
% %reconstruct the data Y_GT as Y_reconstructed_1
%     Reconstruc_test = test_PCA * coeff_1(:,1:N_PC)'+ mu_1;
% 
% %plot cross validation
% 
%     %[~] = recontruction_plot(test_x,Reconstruc_test,'Y_{Reconstruc_train}','Y_{test_x}','PCA cross-validation reconstruction error');
% 
% %mse percentage error
%     mseError_test = mse((test_x-Reconstruc_test)./test_x)
