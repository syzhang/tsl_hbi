function [loglik] = model_io_jump_freq_srp1(parameters, subject)
% IO model with jumps, using std and prob in regression

    nd_pj = parameters(1); % normally distributed
    pj = 1 / (1 + exp(-nd_pj)); % jump prob (positive and integer)

    % unpack data
    seq = subject.seq; % 1 for l, 2 for h
    sess = subject.session; % sessions
    y = subject.p1; % subject ratings

    % observer definition
    in.learned = 'frequency';
    in.jump = 1;
    in.s = seq;
    in.opt.pJ = pj;
    in.verbose = 0;
    in.opt.pgrid = 0:0.05:1; % reduce from 100 to 20 speed up

    % IO probs
    out = IdealObserver(in);
    p = out.surprise(:); % prob given current stim and surprise

    % regress
    BIC = regress_prob(y, p, sess, parameters); 
    loglik = -BIC; % negative BIC=loglik

end
