function [x1, x2, x] = multi_rate(x1, x2, f, A, B, err_clamp_bool)
    
    Af = A(1);
    As = A(2);
    
    Bf = B(1);
    Bs = B(2);
    
    x = x1 + x2;
    if err_clamp_bool
        e = 0;
    else
        e = f - x;
    end
    
    x1 = Af*x1 + Bf*e;
    x2 = As*x2 + Bs*e;
    x = x1+x2;
end