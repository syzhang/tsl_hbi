function [loglik] = model_rw(parameters, subject)
% rescorla-wagner model

    % parameters
    alph = parameters(1); % learning rate
    p1 = 1 / (1 + exp(-alph)); 

    % unpack data
    seq = subject.seq; % 1 for l, 2 for h
    sess = subject.session; % sessions
    y = subject.rating; % subject ratings

    % number of trials
    T = size(seq, 1);
    
    % value calculation
    V = 0; % initialise
    V_rec = [];
    for t = 1:T
        V_rec(t) = V;
        r = seq(t)-1; % high=1, low=0
        V = V + alph * (r - V);
    end

    % normalise values to probs
    % p = nan(T, 1);
    % for t = 1:T
    %     if seq(t) == 1 % low
    %         p(t) = 1-V_rec(t);
    %     else %high
    %         p(t) = V_rec(t);
    %     end
    % end
    p = V_rec;

    % regress
    BIC = regress_prob(y, p, sess, parameters); 
    loglik = -BIC; % negative BIC=loglik

end
