function i_data_length = get_data_length(data_sp, i_st, data_length, min_length, id_max)
%UNTITLED2 此处显示有关此函数的摘要

    for i =min_length:1:data_length
        if abs(data_sp(i_st + i)) >id_max
            break;
        end
    end
    
    i_data_length = min(i-250, data_length);

end

