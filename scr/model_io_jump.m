function [loglik] = model_io_jump(parameters, subject)
% IO model with jumps

    nd_pj = parameters(1); % normally distributed
    pj = 1 / (1 + exp(-nd_pj)); % jump prob (positive and integer)

    % unpack data
    seq = subject.seq; % 1 for l, 2 for h
    sess = subject.session; % sessions
    y = subject.rating; % subject ratings

    % observer definition
    in.learned = 'transition';
    in.jump = 1;
    in.s = seq;
    in.opt.pJ = pj;
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
