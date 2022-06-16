clc
clear
close all

num_trials = 100;
a = 1;
sigma = 1;
beta = 0.001;
N = 10;
e_pref = linspace(-5, 5, N);
w0 = zeros(num_trials, N);
w0(1,:) = 0.05;
u = ones(1, num_trials);
%% Paradigms for different values of z
clc
close all

z = 0.9;
x = paradigm_maker(z, num_trials);
[x_hat, w, e] = paradigm_estimator(x, u, e_pref, w0, a, beta, sigma, N);
figure
hold on
plot(x, 'k', 'LineWidth', 2)
plot(x_hat, 'Color', [1, 1, 1]*0.7, 'LineWidth', 3)
ylim([-0.1, 1.1])

%%
clc
close all

z = 0.5;
x = paradigm_maker(z, num_trials);
[x_hat, w, e] = paradigm_estimator(x, u, e_pref, w0, a, beta, sigma, N);
figure
hold on
plot(x, 'k', 'LineWidth', 2)
plot(x_hat, 'Color', [1, 1, 1]*0.7, 'LineWidth', 3)
ylim([-0.1, 1.1])

%%
clc
close all

z = 0.1;
x = paradigm_maker(z, num_trials);
[x_hat, w, e] = paradigm_estimator(x, u, e_pref, w0, a, beta, sigma, N);
figure
hold on
plot(x, 'k', 'LineWidth', 2)
plot(x_hat, 'Color', [1, 1, 1]*0.7, 'LineWidth', 3)
ylim([-0.1, 1.1])