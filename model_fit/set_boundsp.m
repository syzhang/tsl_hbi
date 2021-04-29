function [lb, ub, sp] = set_boundsp(model_str, nfits)
% setting upper lower bounds and random starting points
    
    model_flag = strcmp(model_str, {'io_jump_freq', 'io_fixed_freq', 'rw', 'random', 'io_jump_trans', 'io_fixed_trans'});
    if sum(model_flag)>0
        lb = [-10];
        ub = [10];
        sp = [randn(nfits, 1)];
    end

end