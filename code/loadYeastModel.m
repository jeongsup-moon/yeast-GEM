function model = loadYeastModel
% loadYeastModel
%   Load the yeast-GEM in a MATLAB environment, requires the RAVEN Toolbox
%   and libSBML to be installed. By default, the model is provided in RAVEN
%   format by default, but can alternatively be converted to COBRA format.
%
%   Input:
%       cobra       true if the model should be provided as COBRA format,
%                   false for RAVEN format (optional, default false)
%
%   Output:
%       model       the yeast-GEM model structure
%
%   Usage: model = loadYeastModel(cobra)

scriptFolder = fileparts(which(mfilename));
currentDir = cd(scriptFolder);
model = importModel('../model/yeast-GEM.xml');
cd(currentDir)
if nargin>0 && cobra==true
    model = ravenCobraWrapper(model);
end
end
