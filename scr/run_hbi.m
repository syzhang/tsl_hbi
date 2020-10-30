function [] = run_hbi(data_path, model_str)
% run hbi on data given model


    % load data
    fdata = load(data_path);
    data  = fdata.subj;
   
    % add cmb/codes to path (different on other machiens)
    addpath(fullfile('..','..','..','MATLAB','cbm','codes'));
    rmpath('folderthatisnotonpath'); % suppress matlab warnings
    
    % run model
    if strcmp(model_str, 'random')
        % set prior
        prior = struct('mean',zeros(1),'variance',10);
        fname_save = ['lap_', model_str, '.mat'];
        cbm_lap(data, @model_random, prior, fname_save);
    end
    
end