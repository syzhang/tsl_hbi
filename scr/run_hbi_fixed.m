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

    wind_list = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,20,30,50,100];
    deca_list = wind_list;
    parameters = [0];
    loglik_mat = [];
    if strcmp(model_str, 'fixed_freq_fit')
        for i=1:length(wind_list)
            for j=1:length(deca_list)
                for k=1:length(data)
                    loglik_mat(i,j,k) = model_io_fixed_freq_fit(parameters, data{k}, wind_list(i), deca_list(j));
                end
            end
        end
        save(fname_save, loglik_mat);
    end
    
end