function [sample, s_type] = getNN(sample_1_type, is_rand)
% 随机排序并封装

    % initial
    N_sample = length(sample_1_type);
    X_frame = size(sample_1_type{1,1}, 1);
    Y_sensor = size(sample_1_type{1,1}, 2);
    sample = zeros(N_sample, X_frame, Y_sensor);
    s_type = zeros(N_sample, 1);

    if is_rand
        % random
        r_s = randperm(size(sample_1_type, 1));
        rand_sample = sample_1_type(r_s, :);
    else
        rand_sample = sample_1_type;
    end
    
    for n = 1:1:N_sample
        for x = 1:1:X_frame
            for y = 1:1:Y_sensor
                sample(n, x, y) = rand_sample{n,1}(x,y);
                % from 1~4 to 0~3
                s_type(n) = rand_sample{n,2} - 1;
            end
        end
    end
    
    
end

