function [p, p_surp, p_pe] = model_rw(parameters, subject)
% rescorla-wagner model

    % parameters
    nd_alph = parameters(1); % learning rate
    alph = 1 / (1 + exp(-nd_alph)); 

    % unpack data
    seq = subject.seq; % 1 for l, 2 for h
    % sess = subject.session; % sessions
    % y = subject.p1; % subject ratings

    % value calculation
    T = length(seq);
    V = 0; % initialise
    assoc = 1; % initial assoc max
    V_rec = [];
    assoc_rec = []; % associability
    pe_rec = []; % prediction error
    for t = 1:T
        V_rec(t) = V;
        assoc_rec(t) = assoc;

        if seq(t)==1
            r = 1; % low pain=reward
        else
            r = 0;
        end
        pe_rec(t) = r - V;
        % update
        V = V + alph * (r - V);
        assoc = abs(r - V);
    end
    p = V_rec;
    p_surp = assoc_rec;
    p_pe = pe_rec;

    % regress
    % BIC = regress_prob(y, p(:), sess, parameters); 
    % loglik = -BIC; % negative BIC=loglik

end
