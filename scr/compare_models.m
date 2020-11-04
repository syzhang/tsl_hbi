function [] = compare_models(data_path)
%compare_models - Description

    % 1st input: data for all subjects
    fdata = load(data_path);
    % data  = fdata.subj;
    data  = fdata.subj(1);

    % 2nd input: a cell input containing function handle to models
    models = {@model_random, @model_io_jump};

    % 3rd input: another cell input containing file-address to files saved by cbm_lap
    fcbm_maps = {'./output/lap_random.mat', 
                './output/lap_io_jump.mat'};

    % 4th input: a file address for saving the output
    fname_hbi = './output/hbi_random_io.mat';

    % run inference
    cbm_hbi(data,models,fcbm_maps,fname_hbi);
end