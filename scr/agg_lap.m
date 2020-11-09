function [] = agg_lap(output_dir)
% aggregating individual lap files in output directory
    
    % add cmb/io to path
    addpath('../../../MATLAB/cbm/codes');
    addpath('../../../MATLAB/MinimalTransitionProbsModel/IdealObserversCode');

    % list lap dirs
    files = dir([output_dir, filesep, 'lap_sub*']);
    % Get a logical vector that tells which is a directory.
    dirFlags = [files.isdir];
    % Extract only those that are directories.
    subFolders = files(dirFlags);
    % get names
    lap_dirs = {};
    for k = 1 : length(subFolders)
        lap_dir = subFolders(k).name;
        lap_path = [subFolders(k).folder, filesep, lap_dir];
        % loop subjects
        d = dir(lap_path);
        lap_sj = d(~ismember({d.name},{'.','..'}));
        sj_num = length(lap_sj);
        fprintf('Sub folder #%d = %s, #files = %d\n', k, lap_path, sj_num);
        fname_subjs = cell(sj_num,1);
        for n = 1:sj_num
            fname_subjs{n} = [lap_sj(n).folder, filesep, lap_sj(n).name];
        end
        % get model name
        tmp = split(lap_path, '/');
        fname_mf = [output_dir,filesep,tmp{end},'.mat'];
        % aggregate
        cbm_lap_aggregate(fname_subjs,fname_mf);
    end
end
