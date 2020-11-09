function [loglik] = model_io_fixed_freq_fit(parameters, subject, window_length, decay_length)
% IO model with fixed window

    wind = window_length; % fixed window length for speed
    deca = decay_length; % fixed window length for speed
    nd_p1 = parameters(1);
    p1 = 1 / (1 + exp(-nd_p1)); 

    % unpack data
    seq = subject.seq; % 1 for l, 2 for h
    sess = subject.session; % sessions
    y = subject.p1; % subject ratings

    % observer definition
    if wind == 0
        in.opt.MemParam = {'Decay', deca};
    elseif deca == 0
        in.opt.MemParam = {'Limited', wind};
    else
        in.opt.MemParam = {'Limited', wind, 'Decay', deca};
    end
    in.learned = 'frequency';
    in.jump = 0;
    in.s = seq;
    in.priorp1 = [p1, 1-p1];
    in.verbose = 0;
    in.opt.pgrid = 0:0.05:1; % reduce from 100 to 20 speed up

    % IO probs
    out = IdealObserver(in);
    p = out.p1_mean(:); % prediction given current stim

    % regress
    BIC = regress_prob(y, p, sess, parameters); 
    loglik = -BIC; % negative BIC=loglik

end
