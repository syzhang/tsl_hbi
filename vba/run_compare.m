function [ep, pep] = run_compare()
% run function compare_bms

    % lap names
    lap_names = {
        '../scr/output/lap_subjects_io_fixed_freq.mat',
        '../scr/output/lap_subjects_io_fixed_trans.mat',
        '../scr/output/lap_subjects_io_jump_freq.mat',
        '../scr/output/lap_subjects_io_jump_trans.mat',
        '../scr/output/lap_random.mat',
        '../scr/output/lap_random2.mat',
        '../scr/output/lap_wsls.mat',
        '../scr/output/lap_rw.mat',
        '../scr/output/lap_ck.mat'
    };
    
    [posterior, out] = compare_bms(lap_names);
    
    % exceedance prob
    ep = out.ep;
    % protected ep
    pep = (1-out.bor)*out.ep + out.bor/length(out.ep);
end