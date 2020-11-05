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
    
    % run model
    fname_save = fullfile('.', 'output', ['lap_', model_str, '.mat']);
    if strcmp(model_str, 'random')
        prior = struct('mean',zeros(1),'variance',5);
        cbm_lap(data, @model_random, prior, fname_save, struct('numinit', 1000));
    elseif strcmp(model_str, 'random2')
        prior = struct('mean',zeros(1,2),'variance',5);
        cbm_lap(data, @model_random2, prior, fname_save, struct('numinit', 5000));
    elseif strcmp(model_str, 'io_fixed')
        prior = struct('mean', [0],'variance',5);
        cbm_lap(data, @model_io_fixed, prior, fname_save, struct('numinit', 1000));
    elseif strcmp(model_str, 'io_jump')
        prior = struct('mean', [-4],'variance',5); % close to true pc=0.016
        cbm_lap(data, @model_io_jump, prior, fname_save, struct('numinit', 1000));
    elseif strcmp(model_str, 'rw')
        prior = struct('mean', [0],'variance',5);
        cbm_lap(data, @model_rw, prior, fname_save, struct('numinit', 1000));
    elseif strcmp(model_str, 'wsls')
        prior = struct('mean', [0],'variance',5);
        cbm_lap(data, @model_wsls, prior, fname_save, struct('numinit', 1000));
    elseif strcmp(model_str, 'ck')
        prior = struct('mean', [0, 0],'variance',5);
        cbm_lap(data, @model_ck, prior, fname_save, struct('numinit', 1000));
    end
    
end