function [lap_paths] = extract_params(dataset)
    % extract fitted params from lap files
    if strcmp(dataset, 'fmri')
        output_dir = '../scr/output';
    elseif strcmp(dataset, 'practice')
        output_dir = '../scr/output_practice';
    elseif strcmp(dataset, 'fmri_rt')
        output_dir = '../scr_rt/output';
    elseif strcmp(dataset, 'practice_rt')
        output_dir = '../scr_rt/output_practice';
    end
    % list dir
    wildcard_str = 'lap*.mat';
    lap_list = dir([output_dir, filesep, wildcard_str]);

    % lap names
    lap_names = {};
    lap_paths = {};
    for f=1:length(lap_list)
        lap_paths{f} = [lap_list(f).folder, filesep, lap_list(f).name];
        lap_names{f} = lap_list(f).name(5:end-4);
    end

    % load lap files
    evidence_mat = [];
    params_mat = [];
    % loglik_mat = [];
    names_mat = [];
    for i = 1:length(lap_names)
        lap_names{i}
        lap_paths{i}
        tmp = load(lap_paths{i});
        model_evidence = tmp.cbm.output.log_evidence;
        n_sj = length(model_evidence);
        names_mat = [names_mat; repmat({lap_names{i}}, n_sj,1)];
        evidence_mat = [evidence_mat; model_evidence(:)];
        params_mat = [params_mat; tmp.cbm.output.parameters(:)];
        length(tmp.cbm.output.parameters(:))
        % loglik_mat = [loglik_mat; tmp.cbm.output.loglik];
    end

    % save to csv
    T = table(names_mat(:), evidence_mat(:), params_mat(:), 'VariableNames',{'model','log_evidence','parameters'});
    save_path = ['./params/',dataset,'.csv'];
    writetable(T,save_path);
end