function file_list = find_index(reg_input, DispData, data_col)
% This function find index due to regular expression
    
    n_data = length(DispData);
    file_list = {};
    j = 0;
    
    switch nargin
        case 2
            for i = 1:1:n_data
                if isempty(regexp(string(DispData(i,1)), reg_input, 'match')) ~= 1
                    j = j + 1;
                    file_list(j,1) = DispData(i,1);
                    file_list(j,2) = DispData(i,end);
                end
            end
        case 3
            for i = 1:1:n_data
                if isempty(regexp(string(DispData(i,1)), reg_input, 'match')) ~= 1
                    j = j + 1;
                    file_list(j,1) = DispData(i,1);
                    file_list(j,2) = DispData(i,data_col);
                end
            end
    end
    
    if j == 0
        disp('No such file found !')
    end
    
end

