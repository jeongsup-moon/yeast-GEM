function saveYeastModel(model,upDATE,allowNoGrowth)
% saveYeastModel
%   Saves model as a .xml, .txt and .yml file. Also updates complementary
%   files (boundaryMets.txt, README.md and dependencies.txt).
%
%   Inputs: model           (struct) Model to save (NOTE: must be COBRA format)
%           upDATE          (bool, opt) If updating the date in the README file
%                           is needed (default true)
%           allowNoGrowth   (bool, opt) if saving should be allowed whenever
%                           the model cannot grow, returning a warning (default
%                           = true), otherwise will error.
%   
%   Usage: saveYeastModel(model,upDATE,allowNoGrowth)
%

if nargin < 2
    upDATE = true;
end

if nargin < 3
    allowNoGrowth = true;
end

%Get and change to the script folder, as all folders are relative to this
%folder
scriptFolder = fileparts(which(mfilename));
currentDir = cd(scriptFolder);

%Set minimal media
cd modelCuration
model = minimal_Y6(model);
cd ..

%Delete model.grRules (redundant and possibly conflicting with model.rules):
if isfield(model,'grRules')
    model = rmfield(model,'grRules');
end

%Update SBO terms in model:
cd missingFields
model = addSBOterms(model);
cd ..

%Save "proteins" ("fbc:name" in the xml file) = "geneNames" ("fbc:label" in the xml file):
model.proteins = model.geneNames;

%Check if model is a valid SBML structure:
writeCbModel(model,'sbml','tempModel.xml');
[~,errors] = TranslateSBML('tempModel.xml');
if ~isempty(errors)
    delete('tempModel.xml');
    error('Model should be a valid SBML structure. Please fix all errors before saving.')
end

%Check if model can grow:
checkGrowth(model,'aerobic',allowNoGrowth)
checkGrowth(model,'anaerobic',allowNoGrowth)

%Update .xml, .txt and .yml models:
copyfile('tempModel.xml','../model/yeast-GEM.xml')
delete('tempModel.xml');
writeCbModel(model,'text','../model/yeast-GEM.txt');
exportForGit(model,'yeast-GEM','../model',{'yml'},false,false);

%Detect boundary metabolites and save them in a .txt file:
fid = fopen('../model/boundaryMets.txt','wt');
for i = 1:length(model.rxns)
    pos = find(model.S(:,i) ~= 0);
    if length(pos) == 1 %Exchange rxn
        fprintf(fid,[model.mets{pos} '\t' model.metNames{pos} '\n']);
    end
end
fclose(fid);

%Update README file: date + size of model
copyfile('../README.md','backup.md')
fin  = fopen('backup.md','r');
fout = fopen('../README.md','w');
still_reading = true;
while still_reading
    inline = fgets(fin);
    if ~ischar(inline)
        still_reading = false;
    else
        if startsWith(inline,'**Last update:** ') && upDATE
            inline = ['**Last update:** ' datestr(datetime,'yyyy-mm-dd') newline];
        elseif startsWith(inline,'|_Saccharomyces cerevisiae_|')
            inline = ['|_Saccharomyces cerevisiae_|[Yeast 7.6]' ...
                '(https://sourceforge.net/projects/yeast/)|' ...
                num2str(length(model.rxns)) '|' ...
                num2str(length(model.mets)) '|' ...
                num2str(length(model.genes)) '|' newline];
        end
        inline=unicode2native(inline,'UTF-8');
        fwrite(fout,inline,'uint8');
    end
end
fclose('all');
delete('backup.md');

%Convert notation "e-005" to "e-05 " in stoich. coeffs. to avoid
%inconsistencies between Windows and MAC:
copyfile('../model/yeast-GEM.xml','backup.xml')
fin  = fopen('backup.xml','r');
fout = fopen('../model/yeast-GEM.xml','w');
still_reading = true;
while still_reading
    inline = fgets(fin);
    if ~ischar(inline)
        still_reading = false;
    else
        if ~isempty(regexp(inline,'[0-9]e-?00[0-9]','once'))
            inline = regexprep(inline,'(?<=[0-9]e-?)00(?=[0-9])','0');
        end
        fwrite(fout,inline);
    end
end
fclose('all');
delete('backup.xml');

%Switch back to original folder
cd(currentDir)

end

%%

function checkGrowth(model,condition,allowNoGrowth)
%Function that checks if the model can grow or not using COBRA under a
%given condition (aerobic or anaerobic). Will either return warnings or
%errors depending on allowNoGrowth.

if strcmp(condition,'anaerobic')
    cd otherChanges
    model = anaerobicModel(model);
    cd ..
end
try
    xPos = strcmp(model.rxnNames,'growth');
    sol  = optimizeCbModel(model);
    if sol.v(xPos) < 1e-6
        dispText = ['The model is not able to support growth under ' ...
                    condition ' conditions. Please ensure the model can grow'];
    end
catch
    dispText = ['The model yields an infeasible simulation using COBRA ' ...
                'under ' condition ' conditions. Please ensure the model ' ...
                'can be simulated with COBRA'];
end

if exist('dispText','var')
    if allowNoGrowth
        warning([dispText ' before opening a PR.'])
    else
        error([dispText ' before comitting.'])
    end
end

end
