function paradigm = paradigm_maker(z, num_trials)

    paradigm = zeros(1, num_trials);
    paradigm(1) = sign(rand-0.5);
    for trial_no = 2:num_trials-1
        if rand < z
            paradigm(trial_no) = paradigm(trial_no-1);
        else
            paradigm(trial_no) = -1*paradigm(trial_no-1);
        end
    end
    paradigm = paradigm > 0;
end