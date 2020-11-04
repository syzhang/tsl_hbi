function [] = run_hbi(data_path, model_str)
% run hbi on data given model

    % load data
    fdata = load(data_path);
    data  = fdata.subj;
   
    % add cmb/io to path
    addpath('../../../MATLAB/cbm/codes');
    addpath('../../../MATLAB/MinimalTransitionProbsModel/IdealObserversCode');
    
    % turn off warnings
    warning('off', 'MATLAB:rankDeficientMatrix')

    % set config
    pconfig = struct('numinit', 1000);
    
    % run model
    fname_save = fullfile('.', 'output', ['lap_', model_str, '.mat']);
    if strcmp(model_str, 'random')
        prior = struct('mean',zeros(1),'variance',10);
        cbm_lap(data, @model_random, prior, fname_save, pconfig);
    elseif strcmp(model_str, 'random2')
        prior = struct('mean',zeros(1,2),'variance',10);
        cbm_lap(data, @model_random2, prior, fname_save, pconfig);
    elseif strcmp(model_str, 'io_fixed')
        prior = struct('mean', [0],'variance',10);
        cbm_lap(data, @model_io_fixed, prior, fname_save, pconfig);
    elseif strcmp(model_str, 'io_jump')
        prior = struct('mean', [-4],'variance',5);
        cbm_lap(data, @model_io_jump, prior, fname_save, pconfig);
    end
    
end