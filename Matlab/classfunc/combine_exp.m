function [data_one] = combine_exp(data_exp_org, round, n_frames)


    start_f = 25;
    fs = 200;
    data_one = zeros(n_frames, 7);
    frames = fs * 6.2/(n_frames - 1); % 每个fem节点的帧数
    
    switch round
        case 1 % 奇数回
            i_start = start_f + 1;
            data_exp = data_exp_org;
        case 0 % 偶数回
            data_exp = flipud(data_exp_org);
            i_start = start_f + find_start(data_exp, 8);
    end
    
    for i = 2:1:n_frames
        data_one(i, 1:7) = data_exp((i - 1) * frames + i_start, 1:7);
    end

%     %  处理第二组的垃圾数据
%     data_one(2, 1:7) = 0;

end

