% This script adds missing metabolites/reactions involving sulfur metabolism,
% as described in Huang et al. 2017 FEMS YR doi:10.1093/femsyr/fox058
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cd ..
model = loadYeastModel;
metsInfo = '../data/modelCuration/VoSulMets.tsv';
rxnsCoeffs = '../data/modelCuration/VoSulRxnsCoeffs.tsv';
rxnsInfo = '../data/modelCuration/VoSulRxns.tsv';
genesInfo = '../data/modelCuration/VoSulGenes.tsv';
newModel = curateMetsRxnsGenes(model,metsInfo,genesInfo,rxnsCoeffs,rxnsInfo);
saveYeastModel(model)
cd modelCuration
