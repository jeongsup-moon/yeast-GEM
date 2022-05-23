%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% addTransNewGPR
% Add changes from the database new anootation for new genes + manual
% curation on those changes
% As for the reference of new GPRs, please find detailed information in:
% data/modelCuration/transRxnNewGPR/TransRxnNewGPR.tsv
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Load model
cd ..
model = loadYeastModel;

% Add new genes
newModel       = curateMetsRxnsGenes(model,'none','../data/modelCuration/transRxnNewGPR/transRxnNewGPRGenes.tsv');

% Change GPR relations
fid           = fopen('../data/modelCuration/transRxnNewGPR/TransRxnNewGPR.tsv');
changegpr     = textscan(fid,'%q %q %q','Delimiter','\t','HeaderLines',1);
newGPR.ID     = changegpr{1};
newGPR.GPR    = changegpr{2};
fclose(fid);

newModel=changeGrRules(newModel,newGPR.ID,newGPR.GPR);

% Delete unused genes (if any)
newModel = deleteUnusedGenes(newModel);
saveYeastModel(newModel)
cd modelCuration
