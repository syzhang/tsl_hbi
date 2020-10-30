function [BIC] = regress_prob(obs_rating, model_prob, session, parameters)
%regress_prob - perform regression on model prob

    y = obs_rating(:); % observed ratings from subject
    p = model_prob(:); % model output prob
    sess = session(:); % indicate sessions within subject

    exnan_idx = ~isnan(y); % indices of not nans
    X = [ones(size(p(exnan_idx))) p(exnan_idx) sess(exnan_idx)]; % design matrix
    % b = regress(y(exnan_idx), X);    % Removes NaN data
    b = X\y(exnan_idx);
    y_hat = b(1) + b(2)*p(exnan_idx) + b(3)*sess(exnan_idx); % predicted ratings
    residuals = y(exnan_idx) - y_hat; % residuals
    meanse = mean(residuals(~isnan(residuals)).^ 2); % mean square error of residuals
    n = length(y(exnan_idx));
    BIC = n*log(meanse) + length(parameters)*log(n);
    % Mayhue 2019 log model likelihood approx
    % loglik = exp((-BIC)./2);
end