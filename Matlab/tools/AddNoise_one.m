function x_noise = AddNoise_one(mat_orig, rate_noise)


%     rate_noise = 4;
    % 长周期噪声在一个过程中相对定值，但是每组数据需要一个不同的权值r_a
    noise_a = [0.00035*4, 0.00068*4, 0.00096*4, 0.0012*4, 0.00096*4, 0.00068*4, 0.00035*4];
    r_a = -1 + 2 * rand(1);
    % 短周期噪声由测量误差决定，0.002
    err = 0.002;
    r_b = rand(length(mat_orig),7);
    r_b = divide_rand(r_b, 5);
    r_b = err .* (r_b - 2);
%     r_b(1,:) = 0; 
%     r_b(:,1) = 0;
%     r_b(:,end) = 0; 

    x_noise = mat_orig;
    for i = 1:1:length(mat_orig)
        for j = 1:1:7
            % 真实值反映在有限元里需要除以倍率4
            x_noise(i,j) = (r_a * noise_a(j) + r_b(i,j)) / rate_noise;
        end
    end
    x_noise = mat_orig + x_noise;
end

