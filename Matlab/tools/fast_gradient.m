acc = 0.01;

x1 = [0.5, 2];
x2 = [0.5, 2];

y_1 = [norm2(b_vbi(x_1(1))), norm2(b_vbi(x_1(2)))];
g_1 = [norm2(b_vbi(x_1(1)+acc))-y_1(1), norm2(b_vbi(x_1(2)+acc))-y_1(2)];
y_2 = [norm2(b_vbi(x_2(1))), norm2(b_vbi(x_2(2)))];
g_2 = [norm2(b_vbi(x_2(1)+acc))-y_2(1), norm2(b_vbi(x_2(2)+acc))-y_2(2)];

n = 0;
n_max = 100;
while n < n_max
    n = n + 1;
    if (x1(2) - x1(1) > acc) && (x2(2) - x2(1) > acc)
        x_mid_1 = find_gradient(x_1(1), y_1(1), g_1(1), x_1(2), y_1(2), g_1(2));
        x_mid_2 = find_gradient(x_2(1), y_2(1), g_2(1), x_2(2), y_2(2), g_2(2));
        y_mid = norm2(b_vbi(x_mid_1, x_mid_2));
        g_mid_1 = norm2(b_vbi(x_mid_1+acc, x_mid_2)) - y_mid;
        g_mid_2 = norm2(b_vbi(x_mid_1, x_mid_2+acc)) - y_mid;
    elseif x1(2) - x1(1) > acc
        x_mid_1 = find_gradient(x_1(1), y_1(1), g_1(1), x_1(2), y_1(2), g_1(2));
        x_mid_2 = x_2(1);
        y_mid = norm2(b_vbi(x_mid_1, x_mid_2));
        g_mid_1 = norm2(b_vbi(x_mid_1+acc, x_mid_2)) - y_mid;
        g_mid_2 = g_2(1);
    elseif x2(2) - x2(1) > acc
        x_mid_1 = x_1(1);
        x_mid_2 = find_gradient(x_2(1), y_2(1), g_2(1), x_2(2), y_2(2), g_2(2));
        y_mid = norm2(b_vbi(x_mid_1, x_mid_2));
        g_mid_1 = g_1(1);
        g_mid_2 = norm2(b_vbi(x_mid_1, x_mid_2+acc)) - y_mid;
    else
        disp(strcat("number of calculation: ", num2str(n)));
        break;
    end

    % update
    if g_mid_1 > 0
        x_1(2) = x_mid_1;
        y_1(2) = y_mid;
        g_1(2) = g_mid_1;
    else
        x_1(1) = x_mid_1;
        y_1(1) = y_mid;
        g_1(1) = g_mid_1;
    end

    if g_mid_2 > 0
        x_2(2) = x_mid_2;
        y_2(2) = y_mid;
        g_2(2) = g_mid_2;
    else
        x_2(1) = x_mid_2;
        y_2(1) = y_mid;
        g_2(1) = g_mid_2;
    end

end








