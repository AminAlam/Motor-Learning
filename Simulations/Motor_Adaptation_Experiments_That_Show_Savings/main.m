clc
clear
close all

addpath '../Paradigms_Functions/'
addpath '../Utils/'

% %%%%%%%%%%%%%%%%%%%%%% Configs
num_trials = 900;
err_clamp_bool = 0;
length_initial_zeros = 20;

% Single-State and Gain-Specific Models
A = 0.99;
B = 0.013;

% Multi-Rate Model
Af = 0.92;
As = 0.996;
Bf = 0.03;
Bs = 0.004;

%% Single-State Model
clc
close all

deadaptation_trials = 401:430;
washout_trials = [];
f = make_disturbance(num_trials, deadaptation_trials, washout_trials,...
                    length_initial_zeros);
                       
x = zeros(1, num_trials);

for trial_no = 2:num_trials
    x(trial_no) = single_state(x(trial_no-1), f(trial_no-1), A, B, err_clamp_bool);
end

figure
hold on
boxy = [-1.1 1.1 1.1 -1.1];
box = [length_initial_zeros length_initial_zeros ...
        deadaptation_trials(1)-1 deadaptation_trials(1)-1];
patch(box,boxy,'k','FaceAlpha',0.1, 'EdgeAlpha', 0)
box = [deadaptation_trials(1) deadaptation_trials(1)...
        deadaptation_trials(end) deadaptation_trials(end)];
patch(box,boxy,'r','FaceAlpha',0.1, 'EdgeAlpha', 0)
box = [deadaptation_trials(end)+1 deadaptation_trials(end)+1 ...
        num_trials num_trials];
patch(box,boxy,'k','FaceAlpha',0.1, 'EdgeAlpha', 0)

plot_disturbance(f, num_trials, deadaptation_trials)
plot(1:num_trials, x, 'r', 'LineWidth', 2)

legend('adaptation trials', 'deadaptation trials', 'redaptation trials',...
    'Disturbance', 'Net Adaptation' ,'Location', 'southeast')

% initial learning vs relearning (null_trials_inserted)
washout_trials = 431:431+50;
f = make_disturbance(num_trials, deadaptation_trials, washout_trials,...
                    length_initial_zeros);
                
x_washout = zeros(1, num_trials);

for trial_no = 2:num_trials
    x_washout(trial_no) = single_state(x_washout(trial_no-1), f(trial_no-1), A, B, err_clamp_bool);
end

figure
hold on
plot(1:300, x(length_initial_zeros+1:length_initial_zeros+300), 'r', 'LineWidth', 2)
plot(1:300, x_washout(washout_trials(end)+1:washout_trials(end)+300), '--r', 'LineWidth', 4)
ylim([0, 0.6])
legend('Initila Learning', 'Re-Learning', 'Location', 'southeast')

% saving vs number of washout trials
washout_trial_start = deadaptation_trials(end)+1;
num_washout_trials = 0:300;
saving_mat = zeros(size(num_washout_trials));

for washout_trials = num_washout_trials
    washout_trials_varying = washout_trial_start:washout_trial_start+washout_trials;
    f = make_disturbance(num_trials, deadaptation_trials, washout_trials_varying,...
                    length_initial_zeros);
    x_washout = zeros(1, num_trials);

    for trial_no = 2:num_trials
        x_washout(trial_no) = single_state(x_washout(trial_no-1), f(trial_no-1), A, B, err_clamp_bool);
    end
    
    x_relearning = x_washout(washout_trials_varying(end)+1:end);
    saving = (x_relearning(30)-x(length_initial_zeros+30))/x(length_initial_zeros+30) * 100;
    saving_mat(washout_trials+1) = saving;
end
figure
plot(num_washout_trials, saving_mat, 'b', 'LineWidth', 2)
ylim([-5 100])

%% Gain Specific Model
clc
close all

deadaptation_trials = 401:416;
washout_trials = [];
f = make_disturbance(num_trials, deadaptation_trials, washout_trials,...
                    length_initial_zeros);
                       
x = zeros(1, num_trials);
x1 = zeros(1, num_trials);
x2 = zeros(1, num_trials);
for trial_no = 2:num_trials
    [x1(trial_no), x2(trial_no), x(trial_no)] = gain_specific(...
        x1(trial_no-1), x2(trial_no-1), f(trial_no-1), A, B, err_clamp_bool);
end

figure
hold on
boxy = [-1.1 1.1 1.1 -1.1];
box = [length_initial_zeros length_initial_zeros ...
        deadaptation_trials(1)-1 deadaptation_trials(1)-1];
patch(box,boxy,'k','FaceAlpha',0.1, 'EdgeAlpha', 0)
box = [deadaptation_trials(1) deadaptation_trials(1)...
        deadaptation_trials(end) deadaptation_trials(end)];
patch(box,boxy,'r','FaceAlpha',0.1, 'EdgeAlpha', 0)
box = [deadaptation_trials(end)+1 deadaptation_trials(end)+1 ...
        num_trials num_trials];
patch(box,boxy,'k','FaceAlpha',0.1, 'EdgeAlpha', 0)

plot_disturbance(f, num_trials, deadaptation_trials)
hold on
plot(1:num_trials, x, 'r', 'LineWidth', 2)
plot(1:num_trials, x1, '--g', 'LineWidth', 2)
plot(1:num_trials, x2, '--b', 'LineWidth', 2)
legend('adaptation trials', 'deadaptation trials', 'redaptation trials', ...
    'Disturbance', 'Net Adaptation', 'Down State', 'Up State', 'Location', 'southeast')

% initial learning vs relearning (null_trials_inserted)
washout_trials = 431:431+50;
f = make_disturbance(num_trials, deadaptation_trials, washout_trials,...
                    length_initial_zeros);
                
x_washout = zeros(1, num_trials);
x1_washout = zeros(1, num_trials);
x2_washout = zeros(1, num_trials);
for trial_no = 2:num_trials
    [x1_washout(trial_no), x2_washout(trial_no), x_washout(trial_no)] = gain_specific(...
        x1_washout(trial_no-1), x2_washout(trial_no-1), f(trial_no-1), A, B, err_clamp_bool);
end

figure
hold on
plot(1:300, x(length_initial_zeros+1:length_initial_zeros+300), 'r', 'LineWidth', 2)
plot(1:300, x_washout(washout_trials(end)+1:washout_trials(end)+300), '--r', 'LineWidth', 4)
ylim([0, 0.6])
legend('Initila Learning', 'Re-Learning', 'Location', 'southeast')

% saving vs number of washout trials
washout_trial_start = deadaptation_trials(end)+1;
num_washout_trials = 0:300;
saving_mat = zeros(size(num_washout_trials));

for washout_trials = num_washout_trials
    washout_trials_varying = washout_trial_start:washout_trial_start+washout_trials;
    f = make_disturbance(num_trials, deadaptation_trials, washout_trials_varying,...
                    length_initial_zeros);
    x_washout = zeros(1, num_trials);
    x1_washout = zeros(1, num_trials);
    x2_washout = zeros(1, num_trials);
    for trial_no = 2:num_trials
        [x1_washout(trial_no), x2_washout(trial_no), x_washout(trial_no)] = gain_specific(...
            x1_washout(trial_no-1), x2_washout(trial_no-1), f(trial_no-1), A, B, err_clamp_bool);
    end
    
    x_relearning = x_washout(washout_trials_varying(end)+1:end);
    saving = (x_relearning(30)-x(length_initial_zeros+30))/x(length_initial_zeros+30) * 100;
    saving_mat(washout_trials+1) = saving;
end
figure
plot(num_washout_trials, saving_mat, 'b', 'LineWidth', 2)
ylim([-5 100])
%% Multi-Rate Model
clc
close all

deadaptation_trials = 401:416;
washout_trials = [];
f = make_disturbance(num_trials, deadaptation_trials, washout_trials,...
                    length_initial_zeros);

x = zeros(1, num_trials);
x1 = zeros(1, num_trials);
x2 = zeros(1, num_trials);
for trial_no = 2:num_trials
    [x1(trial_no), x2(trial_no), x(trial_no)] = multi_rate(...
        x1(trial_no-1), x2(trial_no-1), f(trial_no-1), [Af, As], [Bf, Bs], err_clamp_bool);
end

figure
hold on
boxy = [-1.1 1.1 1.1 -1.1];
box = [length_initial_zeros length_initial_zeros ...
        deadaptation_trials(1)-1 deadaptation_trials(1)-1];
patch(box,boxy,'k','FaceAlpha',0.1, 'EdgeAlpha', 0)
box = [deadaptation_trials(1) deadaptation_trials(1)...
        deadaptation_trials(end) deadaptation_trials(end)];
patch(box,boxy,'r','FaceAlpha',0.1, 'EdgeAlpha', 0)
box = [deadaptation_trials(end)+1 deadaptation_trials(end)+1 ...
        num_trials num_trials];
patch(box,boxy,'k','FaceAlpha',0.1, 'EdgeAlpha', 0)

plot_disturbance(f, num_trials, deadaptation_trials)
hold on
plot(1:num_trials, x, 'r', 'LineWidth', 2)
plot(1:num_trials, x1, '--g', 'LineWidth', 2)
plot(1:num_trials, x2, '--b', 'LineWidth', 2)

legend('adaptation trials', 'deadaptation trials', 'redaptation trials', ...
    'Disturbance', 'Net Adaptation', 'Slow State', 'Fast State', 'Location', 'southeast')

% initial learning vs relearning (null_trials_inserted)
washout_trials = 431:431+50;
f = make_disturbance(num_trials, deadaptation_trials, washout_trials,...
                    length_initial_zeros);
         
x_washout = zeros(1, num_trials);
x1_washout = zeros(1, num_trials);
x2_washout = zeros(1, num_trials);
for trial_no = 2:num_trials
    [x1_washout(trial_no), x2_washout(trial_no), x_washout(trial_no)] = multi_rate(...
        x1_washout(trial_no-1), x2_washout(trial_no-1), f(trial_no-1), [Af, As], [Bf, Bs], err_clamp_bool);
end

figure
hold on
plot(1:300, x(length_initial_zeros+1:length_initial_zeros+300), 'r', 'LineWidth', 2)
plot(1:300, x_washout(washout_trials(end)+1:washout_trials(end)+300), '--r', 'LineWidth', 4)
ylim([0, 0.6])
legend('Initila Learning', 'Re-Learning', 'Location', 'southeast')

% saving vs number of washout trials
washout_trial_start = deadaptation_trials(end)+1;
num_washout_trials = 0:300;
saving_mat = zeros(size(num_washout_trials));

for washout_trials = num_washout_trials
    washout_trials_varying = washout_trial_start:washout_trial_start+washout_trials;
    f = make_disturbance(num_trials, deadaptation_trials, washout_trials_varying,...
                    length_initial_zeros);

    x_washout = zeros(1, num_trials);
    x1_washout = zeros(1, num_trials);
    x2_washout = zeros(1, num_trials);
    for trial_no = 2:num_trials
        [x1_washout(trial_no), x2_washout(trial_no), x_washout(trial_no)] = multi_rate(...
            x1_washout(trial_no-1), x2_washout(trial_no-1), f(trial_no-1), [Af, As], [Bf, Bs], err_clamp_bool);
    end
    
    x_relearning = x_washout(washout_trials_varying(end)+1:end);
    saving = (x_relearning(30)-x(length_initial_zeros+30))/x(length_initial_zeros+30) * 100;
    saving_mat(washout_trials+1) = saving;
end
figure
plot(num_washout_trials, saving_mat, 'b', 'LineWidth', 2)
ylim([-5 100])