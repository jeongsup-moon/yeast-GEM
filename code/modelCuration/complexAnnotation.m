%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% complexAnnotation
% Correct complex annotation
% As for the reference of new GPRs, please find detailed information in:
% data/modelCuration/complexAnnotation/complexAnnotation.tsv
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Load model
cd ..
model = loadYeastModel;

% Add new genes
newModel       = curateMetsRxnsGenes(model,'none','../data/modelCuration/complexAnnotation/complexAnnotationGenes.tsv');

% Add gene standard name for new genes
fid = fopen('../data/modelCuration/complexAnnotation/complexAnnotation.tsv');
complexAnnot = textscan(fid,'%q %q %q %q','Delimiter','\t','HeaderLines',1);
fclose(fid);
newGPR.ID     = complexAnnot{1};
newGPR.GPR    = complexAnnot{3};
newModel=changeGrRules(newModel,newGPR.ID,newGPR.GPR);

% Delete unused genes (if any)
newModel = deleteUnusedGenes(newModel);

% Save model:
saveYeastModel(newModel)
cd modelCuration
