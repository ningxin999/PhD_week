function Y = permutation_plot(data_original,N,explained_1,N_PC)
%ADDME: permutation test figures plotting

%Input: data_original:original data
%       data_reconstruct: reconstructed data


%No output required 
    Y = 'Null';


    N_permutations = N;
    explained_summary = zeros(size(data_original));
    for ii = 1:N_permutations
        for kk = 1:size(data_original, 1)
            data_original_shuffle(kk,:) = data_original(kk,randperm(size(data_original, 2)));
        end

        [coeff_temp,score_temp,latent_temp,~,explained_temp,mu_temp] = pca(data_original_shuffle,'Economy',false);
        explained_summary(ii,:) = explained_temp;
    end
    explained_permutation = mean(explained_summary)' ;
    
    figure();
    plot(1:N_PC,explained_1(1:N_PC));
    hold on;
    plot(1:N_PC,explained_permutation(1:N_PC));

    xlabel('Latent space required');
    ylabel('Explained variance');
    title('Permutation test');

end

