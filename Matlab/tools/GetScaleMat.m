function [trans_mat] = GetScaleMat(d_d00t25, data_all, UD_SCALE)


%     UD_SCALE = 23;
    a = floor(UD_SCALE/10);
    b = mod(UD_SCALE, 10);
    SUM = zeros(size(data_all{1,2}, 1), size(data_all{1,2}, 2));
    if a ~= 0
        for i = 1:1:a
            for k = 1:1:10
                SUM = SUM + data_all{i,k+1};
            end
        end
    end
    for j = 1:1:b
        SUM = SUM + data_all{1+a,b+1};
    end
    e_d00t25 = SUM ./ UD_SCALE;
    % scale matrix
    trans_mat = d_d00t25 ./ (e_d00t25 + eps);

end