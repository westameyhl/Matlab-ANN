function rand_m = divide_rand(rand_m, n_d)


    s_m = size(rand_m);
    for i = 1:1:s_m(1)
        for j = 1:1:s_m(2)
            rand_m(i,j) = floor(rand_m(i,j) * n_d);
        end
    end
end

