% This scripts applies curations to be applied on yeast-GEM release 8.6.0.
% Indicate which Issue/PR are addressed

%% Load yeast-GEM 8.6.0 (requires local yeast-GEM git repository)
cd ..
model = getEarlierModelVersion('8.6.0');
model.id='yeastGEM_develop';

%% Curate complex annotation (PR #305)
% Add new genes
newModel       = curateMetsRxnsGenes(model,'none','../data/modelCuration/v8_6_0/complexAnnotationGenes.tsv');

% Add gene standard name for new genes
fid = fopen('../data/modelCuration/v8_6_0/complexAnnotation.tsv');
complexAnnot = textscan(fid,'%q %q %q %q %q %q %q','Delimiter','\t','HeaderLines',1);
fclose(fid);
newGPR.ID     = complexAnnot{1};
newGPR.GPR    = complexAnnot{3};
newModel=changeGrRules(newModel,newGPR.ID,newGPR.GPR);

% Delete unused genes (if any)
newModel = deleteUnusedGenes(newModel);

%% Curate gene association for transport rxns (PR #306)
% Add new genes
newModel       = curateMetsRxnsGenes(newModel,'none','../data/modelCuration/v8_6_0/transRxnNewGPRGenes.tsv');

% Change GPR relations
fid           = fopen('../data/modelCuration/v8_6_0/TransRxnNewGPR.tsv');
changegpr     = textscan(fid,'%q %q %q %q %q %q %q %q','Delimiter','\t','HeaderLines',1);
newGPR.ID     = changegpr{1};
newGPR.GPR    = changegpr{2};
fclose(fid);

newModel=changeGrRules(newModel,newGPR.ID,newGPR.GPR);

% Delete unused genes (if any)
newModel = deleteUnusedGenes(newModel);

%% Add new gene associations from databases (PR #313)
% Add new genes
newModel       = curateMetsRxnsGenes(newModel,'none','../data/modelCuration/v8_6_0/newGPRsfromDBsGenes.tsv');

% Change GPR relations
fid           = fopen('../data/modelCuration/v8_6_0/newGPRsfromDBs.tsv');
changegpr     = textscan(fid,'%q %q %q %q %q %q %q %q','Delimiter','\t','HeaderLines',1);
newGPR.ID     = changegpr{1};
newGPR.GPR    = changegpr{3};
fclose(fid);

newModel=changeGrRules(newModel,newGPR.ID,newGPR.GPR);

% Delete unused genes (if any)
newModel = deleteUnusedGenes(newModel);

% Show some metrics:
cd modelTests
disp('Run gene essentiality analysis')
[new.accuracy,new.tp,new.tn,new.fn,new.fp] = essentialGenes(newModel);
fprintf('Genes in model: %.4f\n',numel(newModel.genes));
fprintf('Gene essentiality accuracy: %d\n', new.accuracy);
fprintf('Gene essentiality TP: %d\n', numel(new.tp));
fprintf('Gene essentiality TN: %d\n', numel(new.tn));
fprintf('Gene essentiality FP: %d\n', numel(new.fp));
fprintf('Gene essentiality FN: %d\n', numel(new.fn));
disp('\nRun growth analysis')
R2=growth(newModel);
fprintf('R2 of growth prediction: %.4f\n', R2);

% Save model:
cd ..
saveYeastModel(newModel)
cd modelCuration
