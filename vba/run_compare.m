function [ep, pep] = run_compare(output_dir)
% run function compare_bms
% output_dir - output dir of lap_*.mat
% plot_bool - plot output or not

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

    % BMS
    [posterior, out] = compare_bms(lap_paths);
    % exceedance prob
    ep = out.ep;
    % protected ep
    pep = (1-out.bor)*out.ep + out.bor/length(out.ep);

    % save output
    T = table(lap_names', ep', pep', 'VariableNames',{'model_name','exceedance_prob', 'protected_exceedance_prob'});
    if contains(output_dir, 'practice')
        writetable(T,'./output/practice.csv')
    else
        writetable(T,'./output/fmri.csv')
    end
end