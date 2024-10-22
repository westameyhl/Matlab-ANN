function outputcell = get32points(deform_data, i_case, time_list)

    start_from = 1;
    FS = 200;

    outputcell = {};
    reg_input = strcat('DEm', i_case, 'm2k1v20');
    i_file = find_index(reg_input, deform_data);
    data_20 = i_file{1,2};
    
    for m = 1:1:10
        for j = 1:1:length(time_list)
            j_row = floor(time_list(j) * FS + start_from);
            outputcell{m,1}(j,1:7) = data_20{2*m-1,1}(j_row,1:7);
            j_row_2 = 1288 - floor(time_list(j) * FS + start_from);
            outputcell{m,2}(j,1:7) = data_20{2*m,1}(j_row_2,1:7);
        end
    end
    
end

