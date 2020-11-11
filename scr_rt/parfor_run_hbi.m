function [] = parfor_run_hbi(data_path, model_str, dataset)
% parfor loop through subjects in cluster

    % add cmb/io to path
    addpath('../../../MATLAB/cbm/codes');
    addpath('../../../MATLAB/MinimalTransitionProbsModel/IdealObserversCode');

    % turn off warnings
    warning('off', 'MATLAB:rankDeficientMatrix');

    % create a directory for individual output files:
    dir_name = ['lap_subjects_', model_str];
    if strcmp(dataset, 'fmri')
        mkdir(['./output/', dir_name]);
    else
        mkdir(['./output_practice/', dir_name]);
    end

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
        if strcmp(dataset, 'fmri')
            fname_mod_subj = ['./output/',dir_name,'/',fname_sj];
        else
            fname_mod_subj = ['./output_practice/',dir_name,'/',fname_sj];
        end

        if strcmp(model_str, 'io_jump_trans')
            prior = struct('mean', [-4],'variance',5); 
            cbm_lap(data_subj, @model_io_jump_trans, prior, fname_mod_subj, struct('numinit', 100));
        elseif strcmp(model_str, 'io_jump_freq')
            prior = struct('mean', [0],'variance',5); 
            cbm_lap(data_subj, @model_io_jump_freq, prior, fname_mod_subj, struct('numinit', 500));
        elseif strcmp(model_str, 'io_fixed_freq')
            prior = struct('mean', [0],'variance',5); 
            cbm_lap(data_subj, @model_io_fixed_freq, prior, fname_mod_subj, struct('numinit', 500));
        elseif strcmp(model_str, 'io_fixed_trans')
            prior = struct('mean', [-4],'variance',5); 
            cbm_lap(data_subj, @model_io_fixed_trans, prior, fname_mod_subj, struct('numinit', 500));
        elseif strcmp(model_str, 'io_jump_trans_ss')
                prior = struct('mean', [-4],'variance',5); 
                cbm_lap(data_subj, @model_io_jump_trans_ss, prior, fname_mod_subj, struct('numinit', 100));
        elseif strcmp(model_str, 'io_jump_freq_ss')
            prior = struct('mean', [0],'variance',5); 
            cbm_lap(data_subj, @model_io_jump_freq_ss, prior, fname_mod_subj, struct('numinit', 500));
        elseif strcmp(model_str, 'io_fixed_freq_ss')
            prior = struct('mean', [0],'variance',5); 
            cbm_lap(data_subj, @model_io_fixed_freq_ss, prior, fname_mod_subj, struct('numinit', 500));
        elseif strcmp(model_str, 'io_fixed_trans_ss')
            prior = struct('mean', [-4],'variance',5); 
            cbm_lap(data_subj, @model_io_fixed_trans_ss, prior, fname_mod_subj, struct('numinit', 500));
        % elseif strcmp(model_str, 'io_jump_trans_srp')
        %     prior = struct('mean', [-4],'variance',5); 
        %     cbm_lap(data_subj, @model_io_jump_trans_srp, prior, fname_mod_subj, struct('numinit', 100));
        % elseif strcmp(model_str, 'io_jump_freq_srp')
        %     prior = struct('mean', [0],'variance',5); 
        %     cbm_lap(data_subj, @model_io_jump_freq_srp, prior, fname_mod_subj, struct('numinit', 500));
        % elseif strcmp(model_str, 'io_fixed_freq_srp')
        %     prior = struct('mean', [0],'variance',5); 
        %     cbm_lap(data_subj, @model_io_fixed_freq_srp, prior, fname_mod_subj, struct('numinit', 500));
        % elseif strcmp(model_str, 'io_fixed_trans_srp')
        %     prior = struct('mean', [-4],'variance',5); 
        %     cbm_lap(data_subj, @model_io_fixed_trans_srp, prior, fname_mod_subj, struct('numinit', 500));
        elseif strcmp(model_str, 'io_jump_trans_std')
            prior = struct('mean', [-4],'variance',5); 
            cbm_lap(data_subj, @model_io_jump_trans_std, prior, fname_mod_subj, struct('numinit', 100));
    elseif strcmp(model_str, 'io_jump_freq_std1')
        prior = struct('mean', [0],'variance',5); 
        cbm_lap(data_subj, @model_io_jump_freq_std1, prior, fname_mod_subj, struct('numinit', 500));
    elseif strcmp(model_str, 'io_jump_trans_std1')
        prior = struct('mean', [-4],'variance',5); 
        cbm_lap(data_subj, @model_io_jump_trans_std1, prior, fname_mod_subj, struct('numinit', 100));
    elseif strcmp(model_str, 'io_fixed_freq_std1')
        prior = struct('mean', [0],'variance',5); 
        cbm_lap(data_subj, @model_io_fixed_freq_std1, prior, fname_mod_subj, struct('numinit', 500));
    elseif strcmp(model_str, 'io_fixed_trans_std1')
        prior = struct('mean', [-4],'variance',5); 
        cbm_lap(data_subj, @model_io_fixed_trans_std1, prior, fname_mod_subj, struct('numinit', 500));
    elseif strcmp(model_str, 'io_jump_trans_srp1')
        prior = struct('mean', [-4],'variance',5); 
        cbm_lap(data_subj, @model_io_jump_trans_srp1, prior, fname_mod_subj, struct('numinit', 100));
    elseif strcmp(model_str, 'io_jump_freq_srp1')
        prior = struct('mean', [0],'variance',5); 
        cbm_lap(data_subj, @model_io_jump_freq_srp1, prior, fname_mod_subj, struct('numinit', 500));
    elseif strcmp(model_str, 'io_fixed_freq_srp1')
        prior = struct('mean', [0],'variance',5); 
        cbm_lap(data_subj, @model_io_fixed_freq_srp1, prior, fname_mod_subj, struct('numinit', 500));
    elseif strcmp(model_str, 'io_fixed_trans_srp1')
        prior = struct('mean', [-4],'variance',5); 
        cbm_lap(data_subj, @model_io_fixed_trans_srp1, prior, fname_mod_subj, struct('numinit', 500));
        end
end