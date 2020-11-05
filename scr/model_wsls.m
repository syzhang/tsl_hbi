function [loglik] = model_wsls(parameters, subject)
% win-stay-lose-shift model

    nd_win = parameters(1); % normally distributed p(l)
    param = 1 / (1 + exp(-nd_win)); % p(l) (transformed to be between zero and one)

    % unpack data
    seq = subject.seq; % 1 for l, 2 for h
    sess = subject.session; % sessions
    y = subject.p1; % subject ratings

    % number of trials
    T = size(seq, 1);

    % win
    for t=1:T
        p = ones(1,2);
        if t==1 % first trial
            p = p*0.5;
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
    BIC = regress_prob(y, p1, sess, parameters);
    loglik = -BIC; % negative BIC=loglik

end
