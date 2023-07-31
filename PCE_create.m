function myPCE = PCE_create(PCE_data)

%number of FE realization
Nreal = size(PCE_data,1);
%fitting data 
X_val(:,1) = PCE_data(1:Nreal,1);
X_val(:,2) = PCE_data(1:Nreal,2);
Y_val = PCE_data(1:Nreal,3); 
%Select PCE as the metamodeling tool:
metaOpts.Type = 'metamodel';
metaOpts.MetaType = 'PCE';
%Use experimental design data files:
metaOpts.ExpDesign.X = X_val;
metaOpts.ExpDesign.Y = Y_val;
%Set the maximum polynomial degree to 10:
metaOpts.Degree = 1:10;
% Select the sparse-favouring least-square minimization LARS for the 
% PCE coefficients calculation strategy:
metaopts.method = 'LARS';
metaopts.ExpDesign.NSamples = 100;

myPCE = uq_createModel(metaOpts);

end

