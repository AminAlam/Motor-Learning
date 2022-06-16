function g = calculate_g(N, e_n, sigma, e_pref)
    g = zeros(1, N);
    for i = 1:N
        g(i) = exp((-1*(e_n-e_pref(i))^2)/(2*sigma^2));
    end
end