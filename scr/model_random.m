function [loglik] = model_random(parameters, subject)
% random base model assuming H/L with fixed prob

    nd_ph = parameters(1); % normally distributed p(h)
    p_h = 1 / (1 + exp(-nd_ph)); % p(h) (transformed to be between zero and one)
    p_l = 1 - p_h; % p(l) reciprocal to p(h)

    % unpack data
    seq = subject.seq; % 1 for l, 2 for h
    sess = subject.session; % sessions
    y = subject.rating; % subject ratings

    % number of trials
    T = size(seq, 1);

    % initialise prob
    p = nan(T, 1);

    % random prob for h/l
    for t = 1:T
        if seq(t) == 1
            p(t) = p_l;
        elseif seq(t) == 2
            p(t) = p_h;
        end
    end

    exnan_idx = ~isnan(y); % indices of not nans
    X = [ones(size(p(exnan_idx))) p(exnan_idx) sess(exnan_idx)]; % design matrix
    % b = regress(y(exnan_idx), X);    % Removes NaN data
    b = X\y(exnan_idx);
    y_hat = b(1) + b(2)*p(exnan_idx) + b(3)*sess(exnan_idx); % predicted ratings
    residuals = y(exnan_idx) - y_hat; % residuals
    meanse = mean(residuals(~isnan(residuals)).^ 2); % mean square error of residuals
    n = length(y(exnan_idx));
    BIC = n*log(meanse) + length(parameters)*log(n);
    loglik = -BIC+eps; % negative BIC= loglik
end
