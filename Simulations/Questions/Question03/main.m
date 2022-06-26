clc
clear
close all

addpath '../../Paradigms_Functions/'
addpath '../../Utils/'

% %%%%%%%%%%%%%%%%%%%%%% Configs
err_clamp_bool = 0;
length_initial_zeros = 40;


% Single-State and Gain-Specific Models
A = 0.99;
B = 0.013;

% Multi-Rate Model
Af = 0.92;
As = 0.996;
Bf = 0.03; 
Bs = 0.004;

num_trials_init = 900;
deadaptation_trials = [];
washout_trials = [];
f_init = make_disturbance(num_trials_init, deadaptation_trials, washout_trials,...
                    length_initial_zeros);

x_init = zeros(1, num_trials_init);

for trial_no = 2:num_trials_init
    x_init(trial_no) = single_state(x_init(trial_no-1), f_init(trial_no-1), A, B, err_clamp_bool);
end

%% %%%%%%%%%%%%%%%%%%%%%%%%%% Single-State
% Paradigm 1
clc
close all

figure(2)
yline(0, '--k');
hold on

figure(3)
plot(1:num_trials_init-length_initial_zeros, x_init(length_initial_zeros+1:num_trials_init), 'b', 'LineWidth', 2)
hold on

counter = 1;
for length_deadaptation_trials = [30 60 120]*2.5
    deadaptation_trials = 40+length_deadaptation_trials:num_trials_init;
    num_trials = num_trials_init;
    washout_trials = [];
    f = make_disturbance(num_trials, deadaptation_trials, washout_trials,...
                        length_initial_zeros);
    x = zeros(1, num_trials);
    for trial_no = 2:num_trials_init
        x(trial_no) = single_state(x(trial_no-1), f(trial_no-1), A, B, err_clamp_bool);
    end
    
    if counter == 1
        color = 'r';
    elseif counter == 2
        color = 'g';
    else
        color = 'c';
    end
    figure(2)
    plot(1:num_trials, x, color, 'LineWidth', 2, 'LineStyle', '--')
    
    figure(3)
    x_readaptation =  x(40+length_deadaptation_trials+1:num_trials);

    x_readaptation = -1*x_readaptation;
    [M,I] = min(abs(x_readaptation));
    plot(x_readaptation(I:end), color, 'LineWidth', 2, 'LineStyle', '--')
    
    counter = counter+1;
end

figure(2)
plot(1:num_trials_init, x_init, 'b', 'LineWidth', 2)
ylim([-0.7 0.7])
xlabel('Trial Number')
ylabel('Adaptation')

figure(3)
xlim([0 400])
xlabel('Trial Number')
ylabel('Adaptation')
plot([0 400], [0 0], '--k');
legend('Original Adaptation', 'Opposite FF (30 Trials)', 'Opposite FF (60 Trials)', 'Opposite FF (90 Trials)', '', 'Location', 'southeast');
box off
%% Paradigm 2-test
clc
close all

figure(2)
yline(0, '--k');
hold on

figure(3)
plot(1:num_trials_init-length_initial_zeros, x_init(length_initial_zeros+1:num_trials_init), 'b', 'LineWidth', 2)
hold on

counter = 1;
for length_deadaptation_trials = [30 60 120]*2.5
    washout_trials = 40+length_deadaptation_trials:num_trials_init;
    num_trials = num_trials_init;
    deadaptation_trials = [];
    f = make_disturbance(num_trials, deadaptation_trials, washout_trials,...
                        length_initial_zeros);
    x = zeros(1, num_trials);
    for trial_no = 2:num_trials_init
        x(trial_no) = single_state(x(trial_no-1), f(trial_no-1), A, B, err_clamp_bool);
    end
    
    if counter == 1
        color = 'r';
    elseif counter == 2
        color = 'g';
    else
        color = 'c';
    end
    figure(2)
    plot(1:num_trials, x, color, 'LineWidth', 2, 'LineStyle', '--')
    
    figure(3)
    x_readaptation =  x(40+length_deadaptation_trials+1:num_trials);

    [~, I] = min(abs(x_readaptation-0.4));
    x_readaptation = -1*x_readaptation;
    x_readaptation = x_readaptation+0.4;
    x_readaptation = x_readaptation/max(x_readaptation);
    x_readaptation = x_readaptation*max(x_init);
    plot(x_readaptation(I:end), color, 'LineWidth', 2, 'LineStyle', '--')
    
    counter = counter+1;
end

figure(2)
plot(1:num_trials_init, x_init, 'b', 'LineWidth', 2)
ylim([-0.7 0.7])
xlabel('Trial Number')
ylabel('Adaptation')

figure(3)
xlim([0 400])
xlabel('Trial Number')
ylabel('Adaptation')
plot([0 400], [0 0], '--k');
legend('Original Adaptation', 'Opposite FF (30 Trials)', 'Opposite FF (60 Trials)', 'Opposite FF (90 Trials)', '', 'Location', 'southeast');
box off
%% Paradigm 3
clc
close all

figure(2)
yline(0, '--k');
hold on

figure(3)
plot(1:num_trials_init-length_initial_zeros, x_init(length_initial_zeros+1:num_trials_init), 'b', 'LineWidth', 2)
hold on

counter = 1;
for length_deadaptation_trials = [30 60 120]*2.5
    washout_trials = [];
    scale_trials = 40+length_deadaptation_trials:num_trials_init;
    num_trials = num_trials_init;
    deadaptation_trials = [];
    f = make_disturbance(num_trials, deadaptation_trials, washout_trials,...
                        length_initial_zeros);
    f(scale_trials) = 0.3;
    
    x = zeros(1, num_trials);
    for trial_no = 2:num_trials_init
        x(trial_no) = single_state(x(trial_no-1), f(trial_no-1), A, B, err_clamp_bool);
    end
    
    if counter == 1
        color = 'r';
    elseif counter == 2
        color = 'g';
    else
        color = 'c';
    end
    figure(2)
    plot(1:num_trials, x, color, 'LineWidth', 2, 'LineStyle', '--')
    
    figure(3)
    x_readaptation =  x(40+length_deadaptation_trials+1:num_trials);

    [~, I] = min(abs(x_readaptation-0.4));
    x_readaptation = -1*x_readaptation;
    x_readaptation = x_readaptation+0.4;
    x_readaptation = x_readaptation/max(x_readaptation);
    x_readaptation = x_readaptation*max(x_init);
    plot(x_readaptation(I:end), color, 'LineWidth', 2, 'LineStyle', '--')
    
    counter = counter+1;
end

figure(2)
plot(1:num_trials_init, x_init, 'b', 'LineWidth', 2)
ylim([-0.7 0.7])
xlabel('Trial Number')
ylabel('Adaptation')

figure(3)
xlim([0 400])
xlabel('Trial Number')
ylabel('Adaptation')
plot([0 400], [0 0], '--k');
legend('Original Adaptation', 'Opposite FF (30 Trials)', 'Opposite FF (60 Trials)', 'Opposite FF (90 Trials)', '', 'Location', 'southeast');
box off

%% %%%%%%%%%%%%%%%%%%%%%%%%%% Gain-Specific
clc
close all

x_init = zeros(1, num_trials);
x1_init = zeros(1, num_trials);
x2_init = zeros(1, num_trials);
for trial_no = 2:num_trials
    [x1_init(trial_no), x2_init(trial_no), x_init(trial_no)] = gain_specific(...
        x1_init(trial_no-1), x2_init(trial_no-1), f_init(trial_no-1), A, B, err_clamp_bool);
end

% Paradigm 1
clc
close all

figure(2)
yline(0, '--k');
hold on

figure(3)
plot(1:num_trials_init-length_initial_zeros, x_init(length_initial_zeros+1:num_trials_init), 'b', 'LineWidth', 2)
hold on

counter = 1;
for length_deadaptation_trials = [30 60 120]*2.5
    deadaptation_trials = 40+length_deadaptation_trials:num_trials_init;
    num_trials = num_trials_init;
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
    
    if counter == 1
        color = 'r';
    elseif counter == 2
        color = 'g';
    else
        color = 'c';
    end
    figure(2)
    plot(1:num_trials, x, color, 'LineWidth', 2, 'LineStyle', '--')
    
    figure(3)
    x_readaptation =  x(40+length_deadaptation_trials+1:num_trials);

    x_readaptation = -1*x_readaptation;
    [M,I] = min(abs(x_readaptation));
    plot(x_readaptation(I:end), color, 'LineWidth', 2, 'LineStyle', '--')
    
    counter = counter+1;
end

figure(2)
plot(1:num_trials_init, x_init, 'b', 'LineWidth', 2)
ylim([-0.7 0.7])
xlabel('Trial Number')
ylabel('Adaptation')

figure(3)
xlim([0 400])
xlabel('Trial Number')
ylabel('Adaptation')
plot([0 400], [0 0], '--k');
legend('Original Adaptation', 'Opposite FF (30 Trials)', 'Opposite FF (60 Trials)', 'Opposite FF (90 Trials)', '', 'Location', 'southeast');
box off
%% Paradigm 2-test
clc
close all

figure(2)
yline(0, '--k');
hold on

figure(3)
plot(1:num_trials_init-length_initial_zeros, x_init(length_initial_zeros+1:num_trials_init), 'b', 'LineWidth', 2)
hold on

counter = 1;
for length_deadaptation_trials = [30 60 120]*2.5
    washout_trials = 40+length_deadaptation_trials:num_trials_init;
    num_trials = num_trials_init;
    deadaptation_trials = [];
    f = make_disturbance(num_trials, deadaptation_trials, washout_trials,...
                        length_initial_zeros);
    x = zeros(1, num_trials);
    x1 = zeros(1, num_trials);
    x2 = zeros(1, num_trials);
    for trial_no = 2:num_trials
        [x1(trial_no), x2(trial_no), x(trial_no)] = gain_specific(...
            x1(trial_no-1), x2(trial_no-1), f(trial_no-1), A, B, err_clamp_bool);
    end
    
    if counter == 1
        color = 'r';
    elseif counter == 2
        color = 'g';
    else
        color = 'c';
    end
    figure(2)
    plot(1:num_trials, x, color, 'LineWidth', 2, 'LineStyle', '--')
    
    figure(3)
    x_readaptation =  x(40+length_deadaptation_trials+1:num_trials);

    [~, I] = min(abs(x_readaptation-0.4));
    x_readaptation = -1*x_readaptation;
    x_readaptation = x_readaptation+0.4;
    x_readaptation = x_readaptation/max(x_readaptation);
    x_readaptation = x_readaptation*max(x_init);
    plot(x_readaptation(I:end), color, 'LineWidth', 2, 'LineStyle', '--')
    
    counter = counter+1;
end

figure(2)
plot(1:num_trials_init, x_init, 'b', 'LineWidth', 2)
ylim([-0.7 0.7])
xlabel('Trial Number')
ylabel('Adaptation')

figure(3)
xlim([0 400])
xlabel('Trial Number')
ylabel('Adaptation')
plot([0 400], [0 0], '--k');
legend('Original Adaptation', 'Opposite FF (30 Trials)', 'Opposite FF (60 Trials)', 'Opposite FF (90 Trials)', '', 'Location', 'southeast');
box off
%% Paradigm 3
clc
close all

figure(2)
yline(0, '--k');
hold on

figure(3)
plot(1:num_trials_init-length_initial_zeros, x_init(length_initial_zeros+1:num_trials_init), 'b', 'LineWidth', 2)
hold on

counter = 1;
for length_deadaptation_trials = [30 60 120]*2.5
    washout_trials = [];
    scale_trials = 40+length_deadaptation_trials:num_trials_init;
    num_trials = num_trials_init;
    deadaptation_trials = [];
    f = make_disturbance(num_trials, deadaptation_trials, washout_trials,...
                        length_initial_zeros);
    f(scale_trials) = 0.3;
    
    x = zeros(1, num_trials);
    x1 = zeros(1, num_trials);
    x2 = zeros(1, num_trials);
    for trial_no = 2:num_trials
        [x1(trial_no), x2(trial_no), x(trial_no)] = gain_specific(...
            x1(trial_no-1), x2(trial_no-1), f(trial_no-1), A, B, err_clamp_bool);
    end
    
    if counter == 1
        color = 'r';
    elseif counter == 2
        color = 'g';
    else
        color = 'c';
    end
    figure(2)
    plot(1:num_trials, x, color, 'LineWidth', 2, 'LineStyle', '--')
    
    figure(3)
    x_readaptation =  x(40+length_deadaptation_trials+1:num_trials);

    [~, I] = min(abs(x_readaptation-0.4));
    x_readaptation = -1*x_readaptation;
    x_readaptation = x_readaptation+0.4;
    x_readaptation = x_readaptation/max(x_readaptation);
    x_readaptation = x_readaptation*max(x_init);
    plot(x_readaptation(I:end), color, 'LineWidth', 2, 'LineStyle', '--')
    
    counter = counter+1;
end

figure(2)
plot(1:num_trials_init, x_init, 'b', 'LineWidth', 2)
ylim([-0.7 0.7])
xlabel('Trial Number')
ylabel('Adaptation')

figure(3)
xlim([0 400])
xlabel('Trial Number')
ylabel('Adaptation')
plot([0 400], [0 0], '--k');
legend('Original Adaptation', 'Opposite FF (30 Trials)', 'Opposite FF (60 Trials)', 'Opposite FF (90 Trials)', '', 'Location', 'southeast');
box off