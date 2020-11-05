function [] = agg_lap(lap_dir)
% aggregating individual lap files in lap directory
    
    % add cmb/io to path
    addpath('../../../MATLAB/cbm/codes');
    addpath('../../../MATLAB/MinimalTransitionProbsModel/IdealObserversCode');

    fname_subjs = cell(35,1);
    for n=1:length(fname_subjs)
        fname_subjs{n} = [lap_dir,'/',['lap_' num2str(n) '.mat']];
    end
    % get model name
    tmp = split(lap_dir, '/');
    fname_mf = ['./output/',tmp{end},'.mat'];
    cbm_lap_aggregate(fname_subjs,fname_mf);
end