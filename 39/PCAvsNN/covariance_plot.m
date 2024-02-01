function Y = covariance_plot(data_original,data_reconstruct)
%ADDME: covariance figures plotting

%Input: data_original:original data
%       data_reconstruct: reconstructed data
%       xlabelname: name for xlabel
%       ylabelname: name for ylabel
%       titlename: name for title

%No output required 
    Y = 'Null';


    [n,p] = size(data_original);


    De = (data_original-data_reconstruct);
    ErrorCov =De'*De./n;
    h = heatmap(ErrorCov);
    h.FontSize = 14;
    % original Xy label
    h.Colormap = parula;
    grid off;
    Ax = gca;
    %Ax.XDisplayLabels = nan(size(Ax.XDisplayData));
    %Ax.YDisplayLabels = nan(size(Ax.YDisplayData));
    title('Reconstruction error - covariance matrix')

end

