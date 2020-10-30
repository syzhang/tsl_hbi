function [loglik] = model_io_fixed(parameters, subject)
% IO model with fixed window

    nd_win = parameters(1); % normally distributed
    win = round(exp(nd_win)); % window length (positive and integer)
    nd_p1 = parameters(2);
    p1 = 1 / (1 + exp(-nd_p1)); 

    % unpack data
    seq = subject.seq; % 1 for l, 2 for h
    sess = subject.session; % sessions
    y = subject.rating; % subject ratings

    % observer definition
    in.learned = 'frequency';
    in.jump = 0;
    in.opt.MemParam = {'Limited', win};
    in.s = seq;
    in.priorp1 = [p1, 1-p1];
    in.verbose = 0;

    % IO probs
    out = IdealObserver(in);
    p1_mean = out.p1_mean;

    % slice p to match actual ratings
    T = size(seq, 1);
    p = nan(T, 1);
    for t = 1:T
        if seq(t) == 1
            p(t) = p1_mean(t);
        elseif seq(t) == 2
            p(t) = 1 - p1_mean(t);
        end
    end

    % regress
    BIC = regress_prob(y, p, sess, parameters); 
    loglik = -BIC; % negative BIC=loglik

end
