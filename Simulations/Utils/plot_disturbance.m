function plot_disturbance(f, num_trials, deadaptation_interval)

    plot(1:num_trials, f, 'Color', ones(1,3)*0, 'LineWidth', 1)
    ylim([-1.1, 1.1])
    
end