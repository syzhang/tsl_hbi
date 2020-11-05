function [] = compare_models(data_path)
%compare_models - Description

    % add cmb/io to path
    addpath('../../../MATLAB/cbm/codes');
    addpath('../../../MATLAB/MinimalTransitionProbsModel/IdealObserversCode');
    
    % 1st input: data for all subjects
    fdata = load(data_path);
    % data  = fdata.subj;
    data  = fdata.subj(1);

    % 2nd input: a cell input containing function handle to models
    models = {@model_random, @model_io_fixed_freq, @model_io_fixed_trans, @model_io_jump_freq};

    % 3rd input: another cell input containing file-address to files saved by cbm_lap
    fcbm_maps = {'./output/lap_random.mat', 
    './output/lap_subjects_io_fixed_freq.mat',
    './output/lap_subjects_io_fixed_trans.mat',
    './output/lap_subjects_io_jump_freq.mat'};

    % 4th input: a file address for saving the output
    fname_hbi = './output/hbi/hbi_io.mat';

    % run inference
    cbm_hbi(data,models,fcbm_maps,fname_hbi);
end