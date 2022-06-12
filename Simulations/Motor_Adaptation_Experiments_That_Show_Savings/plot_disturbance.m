function plot_disturbance(f, num_trials, deadaptation_interval)

    plot(1:num_trials, f, 'k', 'LineWidth', 2)
    ylim([-1.1, 1.1])
    box = [deadaptation_interval(1) deadaptation_interval(1)...
            deadaptation_interval(end) deadaptation_interval(end)];
    boxy = [-1.1 1.1 1.1 -1.1];
    patch(box,boxy,'r','FaceAlpha',0.1, 'EdgeAlpha', 0)
    
end