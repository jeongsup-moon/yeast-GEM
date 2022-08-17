%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% complexAnnotation
% Correct complex annotation for ATP_complex_mitochondrial
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Load model
cd ..
model = loadYeastModel

% Change gene rules for ATP synthase mitochondrial (r_0226)
newModel = changeGeneAssoc(model, 'r_0226', ['Q0080 and Q0085 and Q0130 and ' ...
        'YBL099W and YBR039W and YDL004W and YDR298C and YDR377W and YJR121W ' ...
        'and YKL016C and YLR295C and YML081C-A and YPL078C and YPL271W and ' ...
        'YDR322C-A and YPR020W and YOL077W-A']);

% Delete unused genes (if any)
newModel = deleteUnusedGenes(newModel, 2);

% Save model:
saveYeastModel(newModel)
