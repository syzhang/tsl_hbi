function [] = agg_lap(lap_dir)
% aggregating individual lap files in lap directory
    
    % add cmb/io to path
    addpath('../../../MATLAB/cbm/codes');
    addpath('../../../MATLAB/MinimalTransitionProbsModel/IdealObserversCode');

    % loop subjects
    if contains(lap_dir, 'practice')
        fname_subjs = cell(33,1);
        % get model name
        tmp = split(lap_dir, '/');
        fname_mf = ['./output_practice/',tmp{end},'.mat'];
    else
        fname_subjs = cell(35,1);
        % get model name
        tmp = split(lap_dir, '/');
        fname_mf = ['./output/',tmp{end},'.mat'];
    end
    for n=1:length(fname_subjs)
        fname_subjs{n} = [lap_dir,'/',['lap_' num2str(n) '.mat']];
    end
    % aggregate
    cbm_lap_aggregate(fname_subjs,fname_mf);
end