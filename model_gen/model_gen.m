function [] = model_gen(model_str, dataset)
    % generate model output given model and dataset
    % add io to path
    addpath('../../../MATLAB/MinimalTransitionProbsModel/IdealObserversCode');

    if strcmp(dataset, 'fmri')
        output_dir = '../scr/output';
    else
        output_dir = '../scr/output_practice';
    end

    if contains(model_str,'io')
        lap_str = ['lap_subjects_', model_str,'.mat'];
    else
        lap_str = ['lap_', model_str,'.mat'];
    end

    % load data
    data_path = ['../data/',dataset,'_behavioural.mat'];
    fdata = load(data_path);
    data  = fdata.subj;
    sj_n = length(data);
    % extract fitted param
    lap_name = [output_dir, filesep, lap_str];
    tmp = load(lap_name);
    parameters = mean(tmp.cbm.output.parameters);
    % apply model
    p_out = [];
    psurp_out = [];
    sj_out = [];
    sess_out = [];
    p1_out = [];
    runtime_out = [];
    start_idx = 1;
    for i = 1:sj_n
        subj_data = data{i};
        end_idx = start_idx+length(subj_data.seq)-1;
        sj_out(start_idx:end_idx) = subj_data.subject;
        sess_out(start_idx:end_idx) = subj_data.session;
        runtime_out(start_idx:end_idx) = subj_data.runtime;
        p1_out(start_idx:end_idx) = subj_data.p1;
        % apply model
        if strcmp(model_str, 'io_jump_freq')
            [p, p_surp] = model_io_jump_freq(parameters, subj_data);
        elseif strcmp(model_str, 'rw')
            [p, p_surp] = model_rw(parameters, subj_data);
        end
        % append output
        [start_idx, end_idx, length(p)]
        p_out(start_idx:end_idx) = p;
        psurp_out(start_idx:end_idx) = p_surp;
        start_idx = start_idx + length(subj_data.seq);
    end
    T = table(sj_out(:), sess_out(:), runtime_out(:), p1_out(:), p_out(:), psurp_out(:), 'VariableNames',{'subject','session','runtime','p1','pmod', 'pmod_surprise'});
    save_path = ['./output/',dataset,'_',model_str,'.csv'];
    writetable(T,save_path);
                
end