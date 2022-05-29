function x = single_state(x, f, A, B, err_clamp_bool)

    if err_clamp_bool
        e = 0;
    else
        e = f - x;
    end

    x = A*x + B*e;
end