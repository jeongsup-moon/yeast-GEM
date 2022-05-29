% This scripts applies curations to be applied on yeast-GEM release 8.6.0.
% Indicate which Issue/PR are addressed

%% Load yeast-GEM 8.6.0 (requires local yeast-GEM git repository)
cd ..
model = getEarlierModelVersion('8.6.0');
model.id='yeastGEM_develop';

%% Define unique subsystems (Issue #11, PR #307)
fid           = fopen('../data/modelCuration/v8_6_0/uniqueSubsystems.tsv');
fileInput     = textscan(fid,'%q %q %q %q %q','Delimiter','\t','HeaderLines',1);
fclose(fid);
subsystem.rxn = fileInput{1};
subsystem.sub = fileInput{5};
%Capitalize first letter
subsystem.sub = regexprep(subsystem.sub,'^(\w)','${upper($0)}');

[a,b] = ismember(subsystem.rxn,model.rxns);
for i=1:numel(b)
    model.subSystems{b(i),1}=subsystem.sub(i);
end

%% DO NOT CHANGE OR REMOVE THE CODE BELOW THIS LINE.
% Show some metrics:
cd modelTests
% disp('Run gene essentiality analysis')
% [new.accuracy,new.tp,new.tn,new.fn,new.fp] = essentialGenes(model);
% fprintf('Genes in model: %.4f\n',numel(model.genes));
% fprintf('Gene essentiality accuracy: %d\n', new.accuracy);
% fprintf('Gene essentiality TP: %d\n', numel(new.tp));
% fprintf('Gene essentiality TN: %d\n', numel(new.tn));
% fprintf('Gene essentiality FP: %d\n', numel(new.fp));
% fprintf('Gene essentiality FN: %d\n', numel(new.fn));
% disp('\nRun growth analysis')
% R2=growth(model);
% fprintf('R2 of growth prediction: %.4f\n', R2);

% Save model:
cd ..
saveYeastModel(model)
cd modelCuration
