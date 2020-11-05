function [] = parfor_run_hbi(data_path, model_str)
% parfor loop through subjects in cluster

    % add cmb/io to path
    addpath('../../../MATLAB/cbm/codes');
    addpath('../../../MATLAB/MinimalTransitionProbsModel/IdealObserversCode');
    
    % create a directory for individual output files:
    dir_name = ['lap_subjects_', model_str];
    mkdir(['./output/', dir_name]);

    % load data
    fdata = load(data_path);
    data  = fdata.subj;
    sj_n = length(data);

    % parfor (n = 1:sj_n, 8) %max 16 cores
    for n = 1:sj_n
        % the input data should be the data of subject n
        data_subj = data(n);

        % output file
        fname_sj = ['lap_', num2str(n), '.mat'];
        fname_mod_subj = ['./output/',dir_name,'/',fname_sj];
        
        if strcmp(model_str, 'io_jump_trans')
            prior = struct('mean', [-4],'variance',5); 
            cbm_lap(data_subj, @model_io_jump_trans, prior, fname_mod_subj, struct('numinit', 500));
        elseif strcmp(model_str, 'io_jump_freq')
            prior = struct('mean', [0],'variance',5); 
            cbm_lap(data_subj, @model_io_jump_freq, prior, fname_mod_subj, struct('numinit', 1000));
        elseif strcmp(model_str, 'io_fixed_freq')
            prior = struct('mean', [0],'variance',5); 
            cbm_lap(data_subj, @model_io_fixed_freq, prior, fname_mod_subj, struct('numinit', 1000));
        elseif strcmp(model_str, 'io_fixed_trans')
            prior = struct('mean', [-4],'variance',5); 
            cbm_lap(data_subj, @model_io_fixed_trans, prior, fname_mod_subj, struct('numinit', 1000));
        end
end