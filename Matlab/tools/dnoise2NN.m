function [data_train, data_test, train_type, test_type, data_info] = dnoise2NN(fem_data, n_train, n_test, data_notuse, is_rand, reg_list)
% 整合所有有限元数据，变成训练的格式
% 输入数据格式：（4N*32*7）三维数组，4N是总个数，32*7是每个样本
% 输出格式：类别列表，整数1234
% 先整合，再打乱数据

    all_sena = length(reg_list) * 4;
    n_type = length(reg_list);
    
    % initial
    sample_train_type = cell(n_train * all_sena, 2);
    sample_test_type = cell(n_test * all_sena, 2);
    % 记录信息
    data_info = {};
    data_info{1,1} = 'n_train';
    data_info{1,2} = n_train;
    data_info{2,1} = 'n_test';
    data_info{2,2} = n_test;
    data_info{3,1} = 'sample_size';
    data_info{3,2} = size(fem_data{1,2});
    
    start_train = 1;
    start_test = 1;
    for i_type = 1:1:n_type
        data_info{i_type + 3,1} = reg_list(i_type);
        data_info{i_type + 3,2} = i_type;
        for k = 1:1:size(fem_data, 1)
            if isempty(regexp(string(fem_data(k,1)), strcat(reg_list(i_type), "\w{3}"), 'match')) ~= 1
                for i_t = (data_notuse + 1):1:size(fem_data, 2)
                    if i_t - data_notuse <= n_train
                        sample_train_type{start_train, 1} = fem_data{k,i_t};
                        sample_train_type{start_train, 2} = i_type;
                        start_train = start_train + 1;
                    else
                        sample_test_type{start_test, 1} = fem_data{k,i_t};
                        sample_test_type{start_test, 2} = i_type;
                        start_test = start_test + 1;
                    end
                end
            end
        end
    end
    
    % 随机排序并封装
    [data_train, train_type] = getNN(sample_train_type, is_rand);
    [data_test, test_type] = getNN(sample_test_type, is_rand);

end

