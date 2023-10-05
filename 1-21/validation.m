clearvars
rng(100,'twister')
uqlab


uq_figure
[I,~] = imread('SimplySupportedBeam.png');
image(I)
axis equal
set(gca, 'visible', 'off');



ModelOpts.mFile = 'uq_SimplySupportedBeam9points';

myModel = uq_createModel(ModelOpts);

Input.Marginals(1).Name = 'b';  % beam width
Input.Marginals(1).Type = 'Lognormal';
Input.Marginals(1).Moments = [0.15 0.0075];  % (m)

Input.Marginals(2).Name = 'h';  % beam height
Input.Marginals(2).Type = 'Lognormal';
Input.Marginals(2).Moments = [0.3 0.015];  % (m)

Input.Marginals(3).Name = 'L';  % beam length
Input.Marginals(3).Type = 'Lognormal';
Input.Marginals(3).Moments = [5 0.05];  % (m)

Input.Marginals(4).Name = 'E';  % Young's modulus
Input.Marginals(4).Type = 'Lognormal';
Input.Marginals(4).Moments = [3e10 4.5e9];  % (Pa)

Input.Marginals(5).Name = 'p';  % uniform load
Input.Marginals(5).Type = 'Lognormal';
Input.Marginals(5).Moments = [1e4 2e3];  % (N/m)



myInput = uq_createInput(Input);



MetaOpts.Type = 'Metamodel';
MetaOpts.MetaType = 'PCE';

MetaOpts.Method = 'LARS'

MetaOpts.TruncOptions.qNorm = 0.75;

MetaOpts.Degree = 2:10;

MetaOpts.ExpDesign.NSamples = 150;
MetaOpts.ExpDesign.Sampling = 'LHS';

myPCE_LARS = uq_createModel(MetaOpts);


