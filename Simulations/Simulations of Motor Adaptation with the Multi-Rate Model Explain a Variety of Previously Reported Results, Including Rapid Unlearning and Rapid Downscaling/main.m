clc
clear
close all

addpath '../Paradigms_Functions/'
addpath '../Utils/'

% %%%%%%%%%%%%%%%%%%%%%% Configs
err_clamp_bool = 0;
length_initial_zeros = 40;

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
x1_init = zeros(1, num_trials_init);
x2_init = zeros(1, num_trials_init);
for trial_no = 2:num_trials_init
    if ~isempty(find(washout_trials==trial_no, 1))
        err_clamp_bool = 1;
    else
        err_clamp_bool = 0;
    end
    [x1_init(trial_no), x2_init(trial_no), x_init(trial_no)] = multi_rate(...
    x1_init(trial_no-1), x2_init(trial_no-1), f_init(trial_no-1), [Af, As], [Bf, Bs], err_clamp_bool);
end

%% Paradigm 1
clc
close all

deadaptation_trials = 101:num_trials_init;
washout_trials = [];
f = make_disturbance(num_trials_init, deadaptation_trials, washout_trials,...
                    length_initial_zeros);

figure(1)
hold on
boxy = [-1.1 1.1 1.1 -1.1];
box = [length_initial_zeros length_initial_zeros ...
        deadaptation_trials(1)-1 deadaptation_trials(1)-1];
patch(box,boxy,'k','FaceAlpha',0.1, 'EdgeAlpha', 0)
box = [deadaptation_trials(1)-1 deadaptation_trials(1)-1 ...
        deadaptation_trials(end) deadaptation_trials(end)];
patch(box,boxy,'r','FaceAlpha',0.1, 'EdgeAlpha', 0)
plot(1:num_trials_init, f, 'k', 'LineWidth', 4)
ylim([-1.1 1.1])
% xlim([1, 150])

figure(2)
yline(0, '--k');
hold on

figure(3)
yline(0, '--k');
hold on

counter = 1;
for length_deadaptation_trials = [30 60 120]*2.5
    deadaptation_trials = 40+length_deadaptation_trials:num_trials_init;
    num_trials = num_trials_init; %deadaptation_trials(end);
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

%     x_readaptation = x_readaptation-min(x_readaptation);
%     x_readaptation = x_readaptation/max(x_readaptation);
% 	x_readaptation = x_readaptation*max(x_init);
    x_readaptation = -1*x_readaptation;
    [M,I] = min(abs(x_readaptation));
    plot(x_readaptation(I:end), color, 'LineWidth', 2, 'LineStyle', '--')
    
    counter = counter+1;
end

figure(2)
plot(1:num_trials_init, x_init, 'b', 'LineWidth', 2)
% xlim([0 4])
ylim([-0.7 0.7])

figure(3)
plot(1:num_trials_init-length_initial_zeros, x_init(length_initial_zeros+1:num_trials_init), 'b', 'LineWidth', 2)
xlim([0 400])
%% Paradigm 2-test
clc
close all

deadaptation_trials = 101:num_trials_init;
washout_trials = [];
f = make_disturbance(num_trials_init, deadaptation_trials, washout_trials,...
                    length_initial_zeros);

figure(1)
hold on
boxy = [-1.1 1.1 1.1 -1.1];
box = [length_initial_zeros length_initial_zeros ...
        deadaptation_trials(1)-1 deadaptation_trials(1)-1];
patch(box,boxy,'k','FaceAlpha',0.1, 'EdgeAlpha', 0)
box = [deadaptation_trials(1)-1 deadaptation_trials(1)-1 ...
        deadaptation_trials(end) deadaptation_trials(end)];
patch(box,boxy,'r','FaceAlpha',0.1, 'EdgeAlpha', 0)
plot(1:num_trials_init, f, 'k', 'LineWidth', 4)
ylim([-1.1 1.1])
% xlim([1, 150])

figure(2)
yline(0, '--k');
hold on

figure(3)
yline(0, '--k');
hold on

counter = 1;
for length_deadaptation_trials = [30 60 120]*2.5
    washout_trials = 40+length_deadaptation_trials:num_trials_init;
    num_trials = num_trials_init; %deadaptation_trials(end);
    deadaptation_trials = [];
    f = make_disturbance(num_trials, deadaptation_trials, washout_trials,...
                        length_initial_zeros);
    x = zeros(1, num_trials);
    x1 = zeros(1, num_trials);
    x2 = zeros(1, num_trials);
    for trial_no = 2:num_trials
        [x1(trial_no), x2(trial_no), x(trial_no)] = multi_rate(...
            x1(trial_no-1), x2(trial_no-1), f(trial_no-1), [Af, As], [Bf, Bs], err_clamp_bool);
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

%     x_readaptation = x_readaptation-min(x_readaptation);
%     x_readaptation = x_readaptation/max(x_readaptation);
% 	x_readaptation = x_readaptation*max(x_init);
    [M,I] = min(abs(x_readaptation));
    [~, I] = min(abs(x_readaptation-0.4));
    x_readaptation = -1*x_readaptation;
    x_readaptation = x_readaptation+0.4;
    x_readaptation = x_readaptation/max(x_readaptation);
    plot(x_readaptation(I:end), color, 'LineWidth', 2, 'LineStyle', '--')
    
    counter = counter+1;
end

figure(2)
plot(1:num_trials_init, x_init, 'b', 'LineWidth', 2)
% xlim([0 4])
ylim([-0.7 0.7])

figure(3)
plot(1:num_trials_init-length_initial_zeros, x_init(length_initial_zeros+1:num_trials_init), 'b', 'LineWidth', 2)
xlim([0 400])
%% Paradigm 3-test
clc
close all

deadaptation_trials = 101:num_trials_init;
washout_trials = [];
f = make_disturbance(num_trials_init, deadaptation_trials, washout_trials,...
                    length_initial_zeros);

figure(1)
hold on
boxy = [-1.1 1.1 1.1 -1.1];
box = [length_initial_zeros length_initial_zeros ...
        deadaptation_trials(1)-1 deadaptation_trials(1)-1];
patch(box,boxy,'k','FaceAlpha',0.1, 'EdgeAlpha', 0)
box = [deadaptation_trials(1)-1 deadaptation_trials(1)-1 ...
        deadaptation_trials(end) deadaptation_trials(end)];
patch(box,boxy,'r','FaceAlpha',0.1, 'EdgeAlpha', 0)
plot(1:num_trials_init, f, 'k', 'LineWidth', 4)
ylim([-1.1 1.1])
% xlim([1, 150])

figure(2)
yline(0, '--k');
hold on

figure(3)
yline(0, '--k');
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
        [x1(trial_no), x2(trial_no), x(trial_no)] = multi_rate(...
            x1(trial_no-1), x2(trial_no-1), f(trial_no-1), [Af, As], [Bf, Bs], err_clamp_bool);
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

%     x_readaptation = x_readaptation-min(x_readaptation);
%     x_readaptation = x_readaptation/max(x_readaptation);
% 	x_readaptation = x_readaptation*max(x_init);
    [M, I] = min(abs(x_readaptation));
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
% xlim([0 4])
ylim([-0.7 0.7])

figure(3)
plot(1:num_trials_init-length_initial_zeros, x_init(length_initial_zeros+1:num_trials_init), 'b', 'LineWidth', 2)
xlim([0 400])
%% Paradigm 2
clc
close all

deadaptation_trials = [];
washout_trials = 100:num_trials_init;
f = make_disturbance(num_trials_init, deadaptation_trials, washout_trials,...
                    length_initial_zeros);

figure
hold on
boxy = [-1.1 1.1 1.1 -1.1];
box = [length_initial_zeros length_initial_zeros ...
        washout_trials(1)-1 washout_trials(1)-1];
patch(box,boxy,'k','FaceAlpha',0.1, 'EdgeAlpha', 0)
plot(1:num_trials_init, f, 'k', 'LineWidth', 4)
ylim([-1.1 1.1])
xlim([1, 150])

figure
yline(0, '--k');
hold on
counter = 1;
for length_deadaptation_trials = [30 60 120]
    deadaptation_trials = [];
    washout_trials = 40+length_deadaptation_trials:40+length_deadaptation_trials+50;
    num_trials = washout_trials(end);
    f = make_disturbance(num_trials, deadaptation_trials, washout_trials,...
                        length_initial_zeros);
    x = zeros(1, num_trials);
    x1 = zeros(1, num_trials);
    x2 = zeros(1, num_trials);
    for trial_no = 2:num_trials
        if ~isempty(find(washout_trials==trial_no, 1))
            err_clamp_bool = 1;
        else
            err_clamp_bool = 0;
        end
        [x1(trial_no), x2(trial_no), x(trial_no)] = multi_rate(...
            x1(trial_no-1), x2(trial_no-1), f(trial_no-1), [Af, As], [Bf, Bs], err_clamp_bool);
    end
    
    if counter == 1
        color = 'r';
    elseif counter == 2
        color = 'g';
    else
        color = 'c';
    end
    plot(1:num_trials, x, color, 'LineWidth', 2, 'LineStyle', '--')
    counter = counter+1;
end

plot(1:num_trials_init, x_init, 'b', 'LineWidth', 2)
xlim([0 210])
ylim([-0.7 0.7])

%% Paradigm 3
clc
close all

deadaptation_trials = [];
washout_trials = 100:num_trials_init;
f = make_disturbance(num_trials_init, deadaptation_trials, washout_trials,...
                    length_initial_zeros);
f(100:num_trials_init) = 0.5;         

figure
hold on
boxy = [-1.1 1.1 1.1 -1.1];
box = [length_initial_zeros length_initial_zeros ...
        washout_trials(1)-1 washout_trials(1)-1];
patch(box,boxy,'k','FaceAlpha',0.1, 'EdgeAlpha', 0)
box = [washout_trials(1)-1 washout_trials(1)-1 ...
        num_trials_init num_trials_init];
patch(box,boxy,'p','FaceAlpha',0.1, 'EdgeAlpha', 0)
plot(1:num_trials_init, f, 'k', 'LineWidth', 4)
ylim([-1.1 1.1])
xlim([1, 150])

figure
yline(0, '--k');
hold on
counter = 1;
for length_deadaptation_trials = [30 60 120]
    deadaptation_trials = [];
    washout_trials = [];
    num_trials = 40+length_deadaptation_trials+40;
    f = make_disturbance(num_trials, deadaptation_trials, washout_trials,...
                        length_initial_zeros);
    f(40+length_deadaptation_trials:end) = 0.5;
    x = zeros(1, num_trials);
    x1 = zeros(1, num_trials);
    x2 = zeros(1, num_trials);
    for trial_no = 2:num_trials
        if ~isempty(find(washout_trials==trial_no, 1))
            err_clamp_bool = 1;
        else
            err_clamp_bool = 0;
        end
        [x1(trial_no), x2(trial_no), x(trial_no)] = multi_rate(...
            x1(trial_no-1), x2(trial_no-1), f(trial_no-1), [Af, As], [Bf, Bs], err_clamp_bool);
    end
    
    if counter == 1
        color = 'r';
    elseif counter == 2
        color = 'g';
    else
        color = 'c';
    end
    plot(1:num_trials, x, color, 'LineWidth', 2, 'LineStyle', '--')
    counter = counter+1;
end

plot(1:num_trials_init, x_init, 'b', 'LineWidth', 2)
xlim([0 210])
ylim([-0.7 0.7])

