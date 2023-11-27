function PriorOpts = DataInput(Input_name, parameter1,parameter2, type)
%DATAINPUT Summary of this function goes here
%   Detailed explanation goes here

if ismatrix(parameter1)
    % tilde means this variable is deleted immediately and is therefore
    % unused. 
    [~,c] = size(parameter1);
    for ii = 1:c
        PriorOpts.Marginals(ii).Name = Input_name{ii};
        PriorOpts.Marginals(ii).Type = type{ii};
        PriorOpts.Marginals(ii).Parameters = [parameter1(ii) parameter2(ii)];
        PriorOpts.Marginals(ii).Bounds = [1e-5 inf];

    end
end


% Create the INPUT object

%myPriorDist = uq_createInput(PriorOpts);
end

