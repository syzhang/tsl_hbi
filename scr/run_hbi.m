function [] = run_hbi(data_path, model_str)
% run hbi on data given model

    % load data
    fdata = load(data_path);
    data  = fdata.subj;
   
    % add cmb/codes to path (personal machine)
    % addpath(fullfile('..','..','..','MATLAB','cbm','codes'));
    % addpath(fullfile('..','..','..','MATLAB','MinimalTransitionProbsModel','IdealObserversCode'));

    % add cmb/codes to path (cluster)
    addpath(fullfile('..','..','misc_repos','cbm','codes'));
    addpath(fullfile('..','..','misc_repos','MinimalTransitionProbsModel','IdealObserversCode'));

    % turn off warnings
    rmpath('folderthatisnotonpath'); % suppress matlab warnings
    warning('off', 'MATLAB:rankDeficientMatrix')
    
    % run model
    fname_save = fullfile('.', 'output', ['lap_', model_str, '.mat']);
    if strcmp(model_str, 'random')
        % set prior
        prior = struct('mean',zeros(1),'variance',10);
        cbm_lap(data, @model_random, prior, fname_save);
    elseif strcmp(model_str, 'random2')
        prior = struct('mean',zeros(1,2),'variance',10);
        cbm_lap(data, @model_random2, prior, fname_save);
    elseif strcmp(model_str, 'io_fixed')
        prior = struct('mean', [2,0],'variance',10);
        cbm_lap(data, @model_io_fixed, prior, fname_save);
    elseif strcmp(model_str, 'io_jump')
        prior = struct('mean', [0],'variance',10);
        cbm_lap(data, @model_io_jump, prior, fname_save);
    end
    
end