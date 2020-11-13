function [ep, pep] = run_compare(output_dir)
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

    % BMS
    lap_paths
    options = [];
    [posterior, out] = compare_bms(lap_paths, options);
    % model frequency
    f = out.Ef;
    % exceedance prob
    ep = out.ep;
    % protected ep
    pep = (1-out.bor)*out.ep + out.bor/length(out.ep);

    % save output
    T = table(lap_names', f(:), ep(:), pep(:), 'VariableNames',{'model_name','model_frequency','exceedance_prob', 'protected_exceedance_prob'});
    if contains(output_dir, 'rt')
        if contains(output_dir, 'practice')
            writetable(T,'./output_rt/practice.csv')
        else
            writetable(T,'./output_rt/fmri.csv')
        end
    else
        if contains(output_dir, 'practice')
            writetable(T,'./output/practice.csv')
        else
            writetable(T,'./output/fmri.csv')
        end
    end

    % save subject stats
    TT = array2table(posterior.r','VariableNames',lap_names);
    if contains(output_dir, 'rt')
        if contains(output_dir, 'practice')
            writetable(TT,'./output_rt/practice_subject.csv')
        else
            writetable(TT,'./output_rt/fmri_subject.csv')
        end
    else
        if contains(output_dir, 'practice')
            writetable(TT,'./output/practice_subject.csv')
        else
            writetable(TT,'./output/fmri_subject.csv')
        end
    end
end