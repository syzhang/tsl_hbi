function [] = run_hbi_fixed(data_path, model_str, dataset)
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

    wind_list = [0:30,40:10:100,150,200];
    deca_list = wind_list;
    parameters = [0];
    loglik_mat = [];
    for i=1:length(wind_list)
        for j=1:length(deca_list)
            tmp = 0.;
            for k=1:length(data)
                if strcmp(model_str, 'fixed_freq_fit')
                    tmp = tmp + model_io_fixed_freq_fit(parameters, data{k}, wind_list(i), deca_list(j));
                elseif strcmp(model_str, 'fixed_trans_fit')
                    tmp = tmp + model_io_fixed_trans_fit(parameters, data{k}, wind_list(i), deca_list(j));
                end
                loglik_mat(i,j) = tmp/length(data);
            end
        end
    end
    save(fname_save, 'loglik_mat');
    % work out max loglik params
    maxMatrix = max(loglik_mat(:));
    [r,c] = find(loglik_mat==maxMatrix);
    fprintf('Max loglik params: window = %d, decay = %d\n', wind_list(r), deca_list(c));
end