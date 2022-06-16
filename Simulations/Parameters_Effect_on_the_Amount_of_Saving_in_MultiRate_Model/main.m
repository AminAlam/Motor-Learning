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
Af_list = ones(1,10)-10.^(linspace(log10(0.047),log10(0.94),10));
Af_list = [0.92, Af_list];
As_list = ones(1,10)-10.^(linspace(log10(0.0008),log10(0.08),10));
As_list = [0.996, As_list];
Bf_list = 10.^linspace(log10(0.021),log10(0.84),10);
Bf_list = [0.03, Bf_list];
Bs_list = 10.^linspace(log10(0.0018),log10(0.18),10);
Bs_list = [0.004, Bs_list];
%% Multi-Rate Model
clc
close all

deadaptation_trials = 401:420;
washout_trials = deadaptation_trials(end):num_trials;
f = make_disturbance(num_trials, deadaptation_trials, washout_trials,...
                    length_initial_zeros);


rebound_mat = zeros(length(Af_list), length(As_list), length(Bf_list), length(Bs_list));
Af_counter = 0;
for Af = Af_list
    Af_counter = Af_counter+1;
    As_counter = 0;
    for As = As_list
        As_counter = As_counter+1;
        Bf_counter = 0;
        for Bf = Bf_list
            Bf_counter = Bf_counter+1;
            Bs_counter = 0;
            for Bs = Bs_list
                Bs_counter = Bs_counter+1;
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
                rebound = max(x(washout_trials(1)+1:end))/max(x(1:washout_trials(1)));
                rebound_mat(Af_counter, As_counter, Bf_counter, Bs_counter) = rebound;
            end
        end
    end
end
%% Af vs As
figure
imagesc(Af_list, As_list, squeeze(rebound_mat(2:end,2:end,1,1)))
xlabel('A_f')
ylabel('A_s')
set(gca,'YDir','normal')
colorbar
caxis([0, 0.8])
%% Bf vs Bs
figure
imagesc(Bf_list, Bs_list, squeeze(rebound_mat(1,1,2:end,2:end)))
xlabel('B_f')
ylabel('B_s')
set(gca,'YDir','normal')
colorbar
caxis([0, 0.4])
%% Af vs Bf
figure
imagesc(Af_list, Bf_list, squeeze(rebound_mat(2:end,1,2:end,1)))
xlabel('A_f')
ylabel('B_f')
set(gca,'YDir','normal')
colorbar
caxis([0, 0.7])
%% As vs Bs
figure
imagesc(As_list, Bs_list, squeeze(rebound_mat(1,2:end,1,2:end)))
xlabel('A_s')
ylabel('B_s')
set(gca,'YDir','normal')
colorbar
caxis([0, 0.7])
%% Af vs Bs
figure
imagesc(Af_list, Bs_list, squeeze(rebound_mat(2:end,1,1,2:end)))
xlabel('A_f')
ylabel('B_s')
set(gca,'YDir','normal')
colorbar
caxis([0, 0.7])
%% As vs Bf
figure
imagesc(As_list, Bf_list, squeeze(rebound_mat(1,2:end,2:end,1)))
xlabel('A_s')
ylabel('B_f')
set(gca,'YDir','normal')
colorbar
caxis([0, 0.7])