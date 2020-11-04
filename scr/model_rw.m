function [loglik] = model_rw(parameters, subject)
% rescorla-wagner model

    % parameters
    alph = parameters(1); % learning rate
    p1 = 1 / (1 + exp(-alph)); 

    % unpack data
    seq = subject.seq; % 1 for l, 2 for h
    sess = subject.session; % sessions
    y = subject.rating; % subject ratings

    % value calculation
    


    % IO probs
    out = IdealObserver(in);
    p = out.p1_mean; % prediction given current stim

    % regress
    BIC = regress_prob(y, p, sess, parameters); 
    loglik = -BIC; % negative BIC=loglik

end
