function [loglik] = model_ck(parameters, subject)
% choice kernel model

    nd_p1 = parameters(1); % normally distributed 
    param(1) = 1 / (1 + exp(-nd_p1)); % 
    nd_p2 = parameters(2); % normally distributed 
    param(2) = 1 / (1 + exp(-nd_p2)); % 

    % unpack data
    seq = subject.seq; % 1 for l, 2 for h
    sess = subject.session; % sessions
    y = subject.p1; % subject ratings

    % number of trials
    T = size(seq, 1);

    % win
    ck = zeros(1,2);
    for t=1:T
        p = exp(param(1)*ck)/sum(exp(param(1)*ck));
        ck = (1-param(2))*ck;
        ck(seq(t)) = ck(seq(t)) + param(2);
        p1(t) = p(1);
        p2(t) = p(2);
    end

    % regress
    BIC = regress_prob(y, p1, sess, parameters);
    loglik = -BIC; % negative BIC=loglik

end
