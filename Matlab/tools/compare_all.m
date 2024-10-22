function result_all = compare_all(data_0, data_j)

    s_d = size(data_0);
    n_row = s_d(1);
    n_col = s_d(2);
    
    result_all = 0;
    for i = 1:1:n_row
        for j = 1:1:n_col
            EOD = (data_0(i,j) - data_j(i,j))^2;
            result_all = result_all + EOD;
        end
    end

end

