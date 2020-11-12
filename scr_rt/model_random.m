function [loglik] = model_random(parameters, subject)
% random base model assuming H/L with fixed uncertainty

    nd_ph = parameters(1); % normally distributed p(h)
    p_h = 1 / (1 + exp(-nd_ph)); % p(h) (transformed to be between zero and one)
    p_l = 1 - p_h; % p(l) reciprocal to p(h)

    % unpack data
    seq = subject.seq; % 1 for l, 2 for h
    sess = subject.session; % sessions
    rating = subject.prob_abs; % subject ratings
    rt = subject.rt; % rating RT

    % number of trials
    T = size(seq, 1);

    % initialise uncertainty
    p = nan(T, 1);

    % random prob for h/l
    for t = 1:T
        if seq(t) == 1
            p(t) = p_l;
        elseif seq(t) == 2
            p(t) = p_h;
        end
    end

    % regress
    BIC = regress_prob(rt, rating, p(:), sess, seq, parameters); 
    loglik = -BIC; % negative BIC=loglik

end
