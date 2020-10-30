function [] = compare_models(data_path)
%compare_models - Description

    % 1st input: data for all subjects
    fdata = load(data_path);
    data  = fdata.subj;

    % 2nd input: a cell input containing function handle to models
    models = {@model_random, @model_random2, @model_io_fixed};
    % note that by handle, I mean @ before the name of the function

    % 3rd input: another cell input containing file-address to files saved by cbm_lap
    save_dir = fullfile('.','output');
    fcbm_maps = {[save_dir,'/lap_random.mat'], [save_dir,'/lap_random2.mat'],[save_dir,'/lap_io_fixed.mat']};
    % note that they corresponds to models (so pay attention to the order)

    % 4th input: a file address for saving the output
    fname_hbi = [save_dir,'/hbi_random_io.mat'];

    % run inference
    cbm_hbi(data,models,fcbm_maps,fname_hbi);
end