function [BIC] = regress_prob(rt, obs_rating, model_prob, session, seq, parameters)
%regress_prob - perform regression on model uncertainty

    y = rt(:); % rating RT
    rating = obs_rating(:); % observed ratings from subject
    p = model_prob; % model output prob
    sess = session(:); % indicate sessions within subject
    seq = seq(:); % stimuli identity
    
    % exnan_idx = ~isnan(y); % indices of not nans
    exnan_idx = ~isnan(rating); % indices of not nans (some RTs are 0 but no probs)
    if size(p,2)==2
        X = [ones(size(p(exnan_idx,1))) p(exnan_idx,:) sess(exnan_idx) rating(exnan_idx) seq(exnan_idx)]; % design matrix
        b = X\y(exnan_idx);
        y_hat = b(1) + b(2)*p(exnan_idx,1)+ b(3)*p(exnan_idx,2) + b(4)*sess(exnan_idx) + b(5)*rating(exnan_idx) + b(6)*seq(exnan_idx); % predicted ratings
        n_params = length(parameters) + 6; % 6 bs in regression
    elseif size(p,2)==1
        X = [ones(size(p(exnan_idx))) p(exnan_idx) sess(exnan_idx) rating(exnan_idx) seq(exnan_idx)]; % design matrix
        b = X\y(exnan_idx);
        y_hat = b(1) + b(2)*p(exnan_idx) + b(3)*sess(exnan_idx) + b(4)*rating(exnan_idx) + b(5)*seq(exnan_idx); % predicted ratings
        n_params = length(parameters) + 5; % 5 bs 
    end
    % if size(p,2)==2
    %     X = [ones(size(p(exnan_idx,1))) p(exnan_idx,:) sess(exnan_idx) rating(exnan_idx)]; % design matrix
    %     b = X\y(exnan_idx);
    %     y_hat = b(1) + b(2)*p(exnan_idx,1)+ b(3)*p(exnan_idx,2) + b(4)*sess(exnan_idx) + b(5)*rating(exnan_idx); % predicted ratings
    %     n_params = length(parameters) + 5; % 5 bs in regression
    % elseif size(p,2)==1
    %     X = [ones(size(p(exnan_idx))) p(exnan_idx) sess(exnan_idx) rating(exnan_idx)]; % design matrix
    %     b = X\y(exnan_idx);
    %     y_hat = b(1) + b(2)*p(exnan_idx) + b(3)*sess(exnan_idx) + b(4)*rating(exnan_idx); % predicted ratings
    %     n_params = length(parameters) + 4; % 4 bs 
    % end
    residuals = y(exnan_idx) - y_hat; % residuals
    meanse = mean(residuals(~isnan(residuals)).^ 2); % mean square error of residuals
    n = length(y(exnan_idx));
    BIC = n*log(meanse) + n_params*log(n);
    % Mayhue 2019 log model likelihood approx
    % loglik = exp((-BIC)./2);
end