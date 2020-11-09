function [loglik] = model_io_fixed_trans_std(parameters, subject)
% IO model with no jump, learning transition

    % nd_win = parameters(1); % normally distributed
    % win = round(exp(nd_win)); % window length (positive and integer)
    win = 10; % fixed window length for speed
    nd_p1 = parameters(1);
    p1 = 1 / (1 + exp(-nd_p1)); 

    % unpack data
    seq = subject.seq; % 1 for l, 2 for h
    sess = subject.session; % sessions
    y = subject.p1; % subject ratings

    % observer definition
    in.learned = 'transition';
    in.jump = 0;
    in.opt.MemParam = {'Limited', win};
    in.s = seq;
    in.priorp1 = [p1, 1-p1];
    in.verbose = 0;
    in.opt.pgrid = 0:0.05:1; % reduce from 100 to 20 speed up

    % IO probs
    out = IdealObserver(in);
    p = [out.p1_mean(:), out.p1_sd(:)]; % prob given current stim and surprise

    % regress
    BIC = regress_prob(y, p, sess, parameters); 
    loglik = -BIC; % negative BIC=loglik

end
