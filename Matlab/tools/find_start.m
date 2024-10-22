function i_start = find_start(data_exp, i_col)
% 在第i_col列找到起始点

    sig = 400;
    i_start = 1;
    while data_exp(i_start, i_col) < sig
        i_start = i_start + 1;
    end
end

