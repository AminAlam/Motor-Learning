function [x1, x2, x] = gain_specific(x1, x2, f, A, B, err_clamp_bool)
    x = x1 + x2;
    if err_clamp_bool
        e = 0;
    else
        e = f - x;
    end
    
    x1 = min(0, A*x1 + B*e);
    x2 = max(0, A*x2 + B*e);
    x = x1+x2;


end