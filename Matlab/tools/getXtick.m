function [x_t, x_tb] = getXtick(data_x, n_tick)

    x_tb = cell(1, n_tick+1);
    x_t = zeros(1, n_tick+1);
    n_jump = ceil(data_x(end) / n_tick);
    for i = 1:1:n_tick+1
        i_x = n_jump * (i - 1);
        x_t(i) = i_x;
        x_tb{1,i} = num2str(i_x);
    end

end

