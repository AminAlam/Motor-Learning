function [x_hat, w, e, g] = paradigm_estimator(x, u, e_pref, w, a, beta, sigma, N)
    x_hat = zeros(1, length(x));
    y_hat = zeros(1, length(x));
    y = x + u;
    e = zeros(1, length(x));
    w(2,:) = w(1, :);
    g = zeros(length(x), N);
    for trial_no = 2:length(x)-1
        y_hat(trial_no) = u(trial_no) + x_hat(trial_no);
        e(trial_no) = y(trial_no) - y_hat(trial_no);
        g(trial_no, :) = calculate_g(N, e(trial_no), sigma, e_pref);
        etha = w(trial_no, :)*g(trial_no, :)';
        g_tmp = calculate_g(N, e(trial_no-1), sigma, e_pref);
        w(trial_no+1, :) = w(trial_no, :) + beta*sign(e(trial_no)*e(trial_no-1))*(g_tmp/(g_tmp*g_tmp'));
        x_hat(trial_no+1) = a*x_hat(trial_no)+etha*e(trial_no);
    end
end