function [posterior, out] = compare_bms(lap_names)
% bayesian model selection given lap files
% lap_names: cell of lap file path
    
    % add cmb/io to path
    cd ../../../MATLAB/VBA-toolbox
    VBA_setup();
    cd ../../tsl/tsl_hbi/vba

    % load lap files
    evidence_mat = [];
    for i = 1:length(lap_names)
        lap_names{i}
        tmp = load(lap_names{i});
        model_evidence = tmp.cbm.output.log_evidence;
        evidence_mat(i, :) = model_evidence;
    end

    % run compare
    [posterior,out] = VBA_groupBMC(evidence_mat);
end