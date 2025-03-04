function fem_original_7 = get_data_7(file_list, n_frame)
% get 32 or 63 frame, 7 sensor


    fem_original_7 = cell(size(file_list));
    n_row = size(file_list{1,2},1);
    n_col = size(file_list{1,2},2);
    temp_cell = cell(n_row-2, n_col-3);
    switch n_frame
        case 32
            for i = 1:1:length(file_list)
                fem_original_7{i,1}{1,1} = file_list{i,1}{1,1};
                s_data = size(file_list{i,2});
                n_row = s_data(1);
                n_col = s_data(2);
                if n_row == 33
                    for m = 2:1:n_row
                        for n = 3:1:n_col-1
                            fem_original_7{i,2}{m-1,n-2} = file_list{i,2}{m,n};
                        end
                    end
                elseif n_row == 64
                    for m = 2:2:n_row
                        for n = 3:1:n_col-1
                            fem_original_7{i,2}{m/2,n-2} = file_list{i,2}{m,n};
                        end
                    end
                end
            end

        case 63
            for i = 1:1:length(file_list)
                fem_original_7{i,1}{1,1} = file_list{i,1}{1,1};

                for m = 3:1:n_row
                    for n = 3:n_col-1
                        temp_cell{m-2,n-2} = file_list{i,2}{m,n};
                    end
                end
                fem_original_7{i,2} = cell2mat(temp_cell);
            end
     end


end

