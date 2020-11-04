function [] = parfor_run_hbi(data_path)
% parfor loop through subjects in cluster

    % add cmb/io to path
    addpath('../../../MATLAB/cbm/codes');
    addpath('../../../MATLAB/MinimalTransitionProbsModel/IdealObserversCode');
    
    % create a directory for individual output files:
    mkdir('./output/lap_subjects_io');

    % load data
    fdata = load(data_path);
    data  = fdata.subj;
    sj_n = length(data);

    % set config
    pconfig = struct('numinit', 1000);

    parfor (n = 1:sj_n, 16) %max 16 cores
        % the input data should be the data of subject n
        data_subj = data(n);

        % a prior struct. The size of mean should 
        % be equal to the number of parameters
        prior = struct('mean', [-4],'variance',10);

        % output file
        fname_sj = ['lap_io_jump', num2str(n), '.mat'];
        fname_mod_subj = ['./output/lap_subjects_io/',fname_sj];

        cbm_lap(data_subj, @model_io_jump, prior, fname_mod_subj, pconfig);
    end
end