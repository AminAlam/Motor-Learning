clc
clear
close all

% %%%%%%%%%%%%%%%%%%%%%% Configs
num_trials = 800;
err_clamp_bool = 0;
diturbance_interval = 400:430;
null_interval = 431:600;

f_relearning = ones(1, num_trials);
f_relearning(1:20) = 0;
f_relearning(diturbance_interval) = -1;

f_relearning_washout = ones(1, num_trials);
f_relearning_washout([1:20, null_interval]) = 0;
f_relearning_washout(diturbance_interval) = -1;

% Single-State and Gain-Specific Models
A = 0.99;
B = 0.013;

% Multi-Rate Model
Af = 0.91;
As = 0.996;
Bf = 0.03;
Bs = 0.004;
%% Showing Different Paradimgs for re-learning
clc
close all
f = f_relearning;
figure
plot(1:num_trials, f, 'k', 'LineWidth', 2)
ylim([-1.2, 1.2])
box = [diturbance_interval(1) diturbance_interval(1)...
        diturbance_interval(end) diturbance_interval(end)];
boxy = [-1.2 1.2 1.2 -1.2];
patch(box,boxy,'r','FaceAlpha',0.1, 'EdgeAlpha', 0)

f = f_relearning_washout;
figure
plot(1:num_trials, f, 'k', 'LineWidth', 2)
ylim([-1.2, 1.2])
box = [diturbance_interval(1) diturbance_interval(1)...
        diturbance_interval(end) diturbance_interval(end)];
boxy = [-1.2 1.2 1.2 -1.2];
patch(box,boxy,'r','FaceAlpha',0.1, 'EdgeAlpha', 0)

%% Single-State Model
clc
close all

f = f_relearning;
x = zeros(1, num_trials);

for trial_no = 2:num_trials
    x(trial_no) = single_state(x(trial_no-1), f(trial_no-1), A, B, err_clamp_bool);
end

figure
plot(1:num_trials, x, 'r', 'LineWidth', 2)
patch(box,boxy,'r','FaceAlpha',0.1, 'EdgeAlpha', 0)
ylim([-0.6, 0.6])
legend('Net Adaptation', 'Location', 'southeast')

f = f_relearning_washout;
x_null = zeros(1, num_trials);

for trial_no = 2:num_trials
    x_null(trial_no) = single_state(x_null(trial_no-1), f(trial_no-1), A, B, err_clamp_bool);
end

% initial learning vs relearning (null_trials_inserted)
figure
hold on
plot(1:200, x(20+1:200+20), 'r', 'LineWidth', 2)

plot(1:200, x_null(null_interval(end)+1:200+null_interval(end)), '--r', 'LineWidth', 4)
ylim([0, 0.6])
legend('Initila Learning', 'Re-Learning', 'Location', 'southeast')
%% Gain Specific Model
clc
close all

f = f_relearning;

x = zeros(1, num_trials);
x1 = zeros(1, num_trials);
x2 = zeros(1, num_trials);
for trial_no = 2:num_trials
    [x1(trial_no), x2(trial_no), x(trial_no)] = gain_specific(...
        x1(trial_no-1), x2(trial_no-1), f(trial_no-1), A, B, err_clamp_bool);
end

f = f_relearning_washout;
x_null = zeros(1, num_trials);
x1_null = zeros(1, num_trials);
x2_null = zeros(1, num_trials);
for trial_no = 2:num_trials
    [x1_null(trial_no), x2_null(trial_no), x_null(trial_no)] = gain_specific(...
        x1_null(trial_no-1), x2_null(trial_no-1), f(trial_no-1), A, B, err_clamp_bool);
end

figure
hold on
plot(1:num_trials, x, 'r', 'LineWidth', 2)
plot(1:num_trials, x1, '--g', 'LineWidth', 2)
plot(1:num_trials, x2, '--b', 'LineWidth', 2)
patch(box,boxy,'r','FaceAlpha',0.1, 'EdgeAlpha', 0)
legend('Net Adaptation', 'Down State', 'Up State', 'Location', 'southeast')
ylim([-0.6, 0.6])

% initial learning vs relearning (null_trials_inserted)
figure
hold on
plot(1:200, x(20+1:200+20), 'r', 'LineWidth', 2)

plot(1:200, x_null(null_interval(end)+1:200+null_interval(end)), '--r', 'LineWidth', 4)
ylim([0, 0.6])
legend('Initila Learning', 'Re-Learning', 'Location', 'southeast')
%% Multi-Rate Model

clc
close all

f = f_relearning;
x = zeros(1, num_trials);
x1 = zeros(1, num_trials);
x2 = zeros(1, num_trials);
for trial_no = 2:num_trials
    [x1(trial_no), x2(trial_no), x(trial_no)] = multi_rate(...
        x1(trial_no-1), x2(trial_no-1), f(trial_no-1), [Af, As], [Bf, Bs], err_clamp_bool);
end

figure
hold on
plot(1:num_trials, x, 'r', 'LineWidth', 2)
plot(1:num_trials, x1, '--g', 'LineWidth', 2)
plot(1:num_trials, x2, '--b', 'LineWidth', 2)
patch(box,boxy,'r','FaceAlpha',0.1, 'EdgeAlpha', 0)
legend('Net Adaptation', 'Slow State', 'Fast State', 'Location', 'southeast')
ylim([-0.6, 0.6])


f = f_relearning_washout;
x_null = zeros(1, num_trials);
x1_null = zeros(1, num_trials);
x2_null = zeros(1, num_trials);
for trial_no = 2:num_trials
    [x1_null(trial_no), x2_null(trial_no), x_null(trial_no)] = multi_rate(...
        x1_null(trial_no-1), x2_null(trial_no-1), f(trial_no-1), [Af, As], [Bf, Bs], err_clamp_bool);
end

% initial learning vs relearning
figure
hold on
plot(1:200, x(20+1:200+20), 'r', 'LineWidth', 2)
plot(1:200, x_null(null_interval(end)+1:200+null_interval(end)), '--r', 'LineWidth', 4)
ylim([0, 0.6])
legend('Initila Learning', 'Re-Learning', 'Location', 'southeast')

