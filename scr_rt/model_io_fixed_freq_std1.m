function [loglik] = model_io_fixed_freq_std1(parameters, subject)
% IO model with fixed window

    nd_p1 = parameters(1);
    p1 = 1 / (1 + exp(-nd_p1)); 

    % unpack data
    seq = subject.seq; % 1 for l, 2 for h
    sess = subject.session; % sessions
    rating = subject.prob_abs; % subject ratings
    rt = subject.rt; % rating RT

    % observer definition
    in.learned = 'frequency';
    in.jump = 0;
    if max(sess)<10 % fmri
        win = 15; % fixed window length for speed
        deca = 5; % decay window length
    else % practice
        win = 20; % fixed window length for speed
        deca = 4; % decay window length
    end
    in.opt.MemParam = {'Limited', win, 'Decay', deca};
    in.s = seq;
    in.priorp1 = [p1, 1-p1];
    in.verbose = 0;
    in.opt.pgrid = 0:0.05:1; % reduce from 100 to 20 speed up

    % IO probs
    out = IdealObserver(in);
    p = out.p1_sd(:); % prob given current stim and surprise

    % regress
    BIC = regress_prob(rt, rating, p(:), sess, parameters); 
    loglik = -BIC; % negative BIC=loglik

end
