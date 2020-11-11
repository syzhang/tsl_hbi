function [loglik] = model_wsls(parameters, subject)
% win-stay-lose-shift model

    nd_win = parameters(1); % normally distributed p(l)
    param = 1 / (1 + exp(-nd_win)); % p(l) (transformed to be between zero and one)

    % unpack data
    seq = subject.seq; % 1 for l, 2 for h
    sess = subject.session; % sessions
    rating = subject.prob_abs; % subject ratings
    rt = subject.rt; % rating RT

    % number of trials
    T = size(seq, 1);

    % win
    p_rec = [];
    p = 0.5*ones(1,2);
    for t=1:T
        p_rec(t) = p(seq(t));
        if t==1 % first trial
            p = p;
        else
            if seq(t)==seq(t-1) % same as previous trial is win
                p = param/2*p;
                p(seq(t)) = 1-param/2;
            else % different is lose
                p = (1-param/2)*p;
                p(seq(t)) = param/2;
            end
        end
        p1(t) = p(1);
        p2(t) = p(2);
    end

    % regress
    BIC = regress_prob(rt, rating, p_rec(:), sess, parameters); 
    loglik = -BIC; % negative BIC=loglik

end
