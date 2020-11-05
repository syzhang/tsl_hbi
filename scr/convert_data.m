function [] = convert_data(csv_path)    
% convert behavioural data from csv to hbi format

    % import csv as table
    csv_file = fullfile(csv_path);
    T = readtable(csv_file);
    
    % extract subject
    subj = {};
    subj_all = unique(T.subject);
    subj_n = 1; % initialise
    
    for i = 1:length(subj_all)
        sj = subj_all(i);
        df_sj = T(T.subject==sj,:);
        subj{subj_n}.seq = df_sj.seq;
        subj{subj_n}.p1 = df_sj.obs_p1;
        subj{subj_n}.session = df_sj.session;
        subj_n = subj_n + 1;
    end

    % save data
    save('../data/fmri_behavioural.mat', 'subj');
    
end