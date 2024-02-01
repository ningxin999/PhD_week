function Y = recontruction_plot(data_original,data_reconstruct,xlabelname,ylabelname,titlename)
%ADDME: Plot reconstruction figures

%Input: data_original:original data
%       data_reconstruct: reconstructed data
%       xlabelname: name for xlabel
%       ylabelname: name for ylabel
%       titlename: name for title

%No output required 
    Y = 'Null';


    LB = min([min(data_original,[],'all')  min(data_reconstruct,[],'all')]) ;
    UB = max([max(data_original,[],'all')  max(data_reconstruct,[],'all')]) ;
    %increase the range by 10%
    LB = LB - 0.1.*abs(LB);
    UB = UB + 0.1.*abs(UB);  

    figure();
    plot(data_original, data_reconstruct, '+');
    hold on;                        
    axis equal;
    axis([[LB UB ], [LB UB ]]);                        
    plot([LB UB ], [LB UB ], 'k');
    xlabel(xlabelname);
    ylabel(ylabelname);
    title(titlename);
    box on;
    hold off;  

end

