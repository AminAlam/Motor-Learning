function f = make_disturbance(num_trials, deadaptation_interval, washout_interval,...
                           length_initial_zeros)

    f = ones(1, num_trials);
    f(1:length_initial_zeros) = 0;
    f(deadaptation_interval) = -1;
    f(washout_interval) = 0;
end