clc
clear
close all

% %%%%%%%%%%%%%%%%%%%%%% Configs

% Single-State and Gain-Specific Models
A = 0.99;
B = 0.013;

% Multi-Rate Model
Af = 0.91;
As = 0.996;
Bf = 0.03;
Bs = 0.004;

%% Single-State Model
num_trials = 800;
f = ones(1, num_trials);
f([1:20, 400:410]) = 0;
x = zeros(1, num_trials);
err_clamp_bool = 0;

for trial_no = 2:num_trials
    x(trial_no) = single_state(x(trial_no-1), f(trial_no-1), A, B, err_clamp_bool);
end

figure
plot(1:num_trials, x, 'r', 'LineWidth', 2)
ylim([-0.6, 0.6])



