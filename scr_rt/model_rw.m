function [loglik] = model_rw(parameters, subject)
% rescorla-wagner model (associability as uncertainty)

    % parameters
    nd_alph = parameters(1); % learning rate
    alph = 1 / (1 + exp(-nd_alph)); 

    % unpack data
    seq = subject.seq; % 1 for l, 2 for h
    sess = subject.session; % sessions
    rating = subject.p1; % subject ratings
    rt = subject.rt; % rating RT

    % number of trials
    T = size(seq, 1);
    
    % value calculation
    V = 0; % initialise
    assoc = 1; % initial assoc max
    V_rec = [];
    assoc_rec = []; % associability
    for t = 1:T
        V_rec(t) = V;
        assoc_rec(t) = assoc;
        if seq(t)==1
            r = 1; % low pain=reward
        else
            r = 0;
        end
        % update
        V = V + alph * (r - V);
        assoc = abs(r - V);
    end
    % p = V_rec;
    p = assoc_rec;

    % regress
    BIC = regress_prob(rt, rating, p(:), sess, parameters); 
    loglik = -BIC; % negative BIC=loglik

end
