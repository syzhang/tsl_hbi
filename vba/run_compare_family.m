function [ep, pep, fep] = run_compare_family(output_dir)
% run function compare_bms
% output_dir - output dir of lap_*.mat

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

    % determine family
    % lap_paths'
    % options.families = {[1,2,16,3],[4,5,6], [7,8,9], [10,11,12], [13,14,15]} ; % including std and srp models
    options.families = {[1,2,8],[3], [4,5,6,7]} ; % excluding std and srp models

    % BMS
    [posterior, out] = compare_bms(lap_paths, options);
    % exceedance prob
    ep = out.ep;
    % protected ep
    pep = (1-out.bor)*out.ep + out.bor/length(out.ep);
    % family frequency and exceedance prob
    ff = out.families.Ef;
    fep = out.families.ep;
    
    % save output
    T = table(lap_names', ep', pep', 'VariableNames',{'model_name','exceedance_prob', 'protected_exceedance_prob'});
    if contains(output_dir, 'practice')
        writetable(T,'./output/practice_family.csv')
    else
        writetable(T,'./output/fmri_family.csv')
    end
end