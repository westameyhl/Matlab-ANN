classdef AnnDataGererator < handle
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here

    properties
         case_list_orig;
         file_type;
         main_path;
         r_project;
         r_date;
         r_mk;
         UD_SCALE;

         frames = 63;
         rate_m;
         file_list;
         case_list;
         data_all;
         data_all_t;

         data_train;
         data_test;
         train_type;
         test_type;
         data_info;
    end

    methods
        function obj = AnnDataGererator(case_list_orig, file_type, main_path, r_project, r_date, r_mk, UD_SCALE)
            %UNTITLED2 Construct an instance of this class
            %   Detailed explanation goes here
            obj.file_type = file_type;
            obj.case_list_orig = case_list_orig;
            obj.main_path = main_path;
            obj.UD_SCALE = UD_SCALE;
            obj.r_date = r_date;
            obj.r_mk = r_mk;
            obj.r_project = r_project;

            addpath(strcat(main_path, 'MatData'));
            addpath(genpath('tools'));
        
            % deform_data = load('C:\westame\Matlab\data\DispData.mat');
            deform_data = load(strcat(main_path, 'MatData\DispData.mat'));
            deform_data = deform_data.DispData;
            reg_input = strcat("DEm\w{6}", obj.r_mk, "v20");
            obj.file_list = find_index(reg_input, deform_data);
            
            %GET SCALE RATE OF MASS 
            if isempty(regexp(r_mk, 'm1\w{2}', 'match')) ~= 1
                obj.rate_m = 0.963 * 12.15/13.77;
            elseif isempty(regexp(r_mk, 'm2\w{2}', 'match')) ~= 1
                obj.rate_m = 1;
            elseif isempty(regexp(r_mk, 'm3\w{2}', 'match')) ~= 1
                obj.rate_m = 0.963 * 14.92/13.77;
            end

            % GET CASE LIST
            m = 1;
            temp_list = ["t25", "t35", "t45", "t55"];
            obj.case_list = strings(1, length(case_list_orig) * length(temp_list));
            for i = 1:1:length(case_list_orig)
                for j = 1:1:length(temp_list)
                    obj.case_list(m) = strcat(case_list_orig(i), temp_list(j));
                    m = m + 1;
                end
            end

        end


        function obj = combine_exp(obj)
            % get data of all (not scaled yet)

            obj.data_all = cell(length(obj.case_list), 21);
            for i = 1:1:length(obj.case_list)
                obj.data_all{i,1} = obj.case_list(i);
                reg_input = strcat('DEm', obj.case_list(i), obj.r_mk, 'v20');
                data_exp = find_index(reg_input, obj.file_list);
                len_data = length(data_exp{1,2}) - 1;
                % v=0.926
                for j = 1:1:len_data
                    j_round = ceil(j/2)+1;
                    n_j = j_round + rem(j+1, 2) * (len_data / 2); 
                    one_data= combine_exp(data_exp{1,2}{j,1}, rem(j, 2), obj.frames);
                    obj.data_all{i,n_j} = one_data .* obj.rate_m;
        %             one_data = combine_exp(data_exp{1,2}{j,1}, rem(j, 2), frames);
        %             data_all{i,n_j} = normalize(-one_data, 'range');
                end
            end


        end

        function obj = scale_all(obj, sc_type, ratio_conv)
            % scale according to harhamart product
            % sc_type: 1: hardamart product
            % sc_type: 2: convolutional cernel
       
            deform_FEM = load(strcat(obj.main_path, obj.r_project, '\Matlab\AddNoise_10000_1000.mat'));
            deform_FEM = deform_FEM.fem_AddNoise;
        %     此处 data_all已经筛选好了，只需要根据前40个更新矩阵即可
            d_d00t25 = deform_FEM{1,2};
            ScaleMat = ScalingTools(d_d00t25, obj.data_all, obj.UD_SCALE, ratio_conv);

            % SCALE all
            switch sc_type
                case 1
                    obj.data_all_t = ScaleMat.sm_hadamard();
                case 2
                    obj.data_all_t = ScaleMat.sm_convolution();
                case 3
                    obj.data_all_t = ScaleMat.sm_selfecoder();
            end

        end


        function obj = dnoise2NN(obj)
        % 整合所有有限元数据，变成训练的格式
        % 输入数据格式：（4N*32*7）三维数组，4N是总个数，32*7是每个样本
        % 输出格式：类别列表，整数1234
        % 先整合，再打乱数据
        
            fem_data = obj.data_all_t;
            n_train = 10;
            n_test = 10;
            data_notuse = 1;
            is_rand = 0;
            reg_list = obj.case_list_orig;

            all_sena = length(reg_list) * 4;
            n_type = length(reg_list);
            
            % initial
            sample_train_type = cell(n_train * all_sena, 2);
            sample_test_type = cell(n_test * all_sena, 2);
            % 记录信息
            obj.data_info = {};
            obj.data_info{1,1} = 'n_train';
            obj.data_info{1,2} = n_train;
            obj.data_info{2,1} = 'n_test';
            obj.data_info{2,2} = n_test;
            obj.data_info{3,1} = 'sample_size';
            obj.data_info{3,2} = size(fem_data{1,2});
            
            start_train = 1;
            start_test = 1;
            for i_type = 1:1:n_type
                obj.data_info{i_type + 3,1} = reg_list(i_type);
                obj.data_info{i_type + 3,2} = i_type;
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
            [obj.data_train, obj.train_type] = getNN(sample_train_type, is_rand);
            [obj.data_test, obj.test_type] = getNN(sample_test_type, is_rand);
        end


        function obj = save_data(obj)
            sample_go = obj.data_train;
            sample_back = obj.data_test;
            type_go = obj.train_type;
            type_back = obj.test_type;
            sample_info = obj.data_info;
            file_route = strcat(obj.main_path, obj.r_project, '\Matlab\DataNeuNet\', obj.r_date, '\', obj.r_mk, '\');
            mkdir(strcat(file_route, obj.file_type, "\", num2str(obj.UD_SCALE)));
            file_name = strcat(file_route, obj.file_type, "\", num2str(obj.UD_SCALE), '\sample_go.mat');
            save(file_name, 'sample_go');
            file_name = strcat(file_route, obj.file_type, "\", num2str(obj.UD_SCALE), '\sample_back.mat');
            save(file_name, 'sample_back');
            file_name = strcat(file_route, obj.file_type, "\", num2str(obj.UD_SCALE), '\type_go.mat');
            save(file_name, 'type_go');
            file_name = strcat(file_route, obj.file_type, "\", num2str(obj.UD_SCALE), '\type_back.mat');
            save(file_name, 'type_back');
            file_name = strcat(file_route, obj.file_type, "\", num2str(obj.UD_SCALE), '\sample_info.mat');
            save(file_name, 'sample_info');
        end


    end
end