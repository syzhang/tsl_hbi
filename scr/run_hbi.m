function [] = run_hbi(data_path, model_str, dataset)
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
    if strcmp(dataset, 'fmri')  
        fname_save = fullfile('.', 'output', ['lap_', model_str, '.mat']);
    else
        fname_save = fullfile('.', 'output_practice', ['lap_', model_str, '.mat']);
    end

    if strcmp(model_str, 'random')
        prior = struct('mean',zeros(1),'variance',5);
        cbm_lap(data, @model_random, prior, fname_save, struct('numinit', 1000));
    elseif strcmp(model_str, 'random2')
        prior = struct('mean',zeros(1,2),'variance',5);
        cbm_lap(data, @model_random2, prior, fname_save, struct('numinit', 5000));
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