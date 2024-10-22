function [] = D_EXP_62s(case_list_orig, file_type, main_path, r_project, r_date, r_mk, UD_SCALE)


    % addpath('C:\westame\Matlab\data');
    % addpath(genpath('funclist'));
    addpath(strcat(main_path, 'MatData'));
    addpath(genpath('funclist'));

    % deform_data = load('C:\westame\Matlab\data\DispData.mat');
    deform_data = load(strcat(main_path, 'MatData\DispData.mat'));
    deform_data = deform_data.DispData;
    
    if isempty(regexp(r_mk, 'm1\w{2}', 'match')) ~= 1
        rate_m = 0.963 * 12.15/13.77;
    elseif isempty(regexp(r_mk, 'm2\w{2}', 'match')) ~= 1
        rate_m = 1;
    elseif isempty(regexp(r_mk, 'm3\w{2}', 'match')) ~= 1
        rate_m = 0.963 * 14.92/13.77;
    end

    % 不做质量缩放
%     rate_m = 1;

%     r_mk = 'm2k1';
    reg_input = strcat("DEm\w{6}", r_mk, "v20");
    file_list = find_index(reg_input, deform_data);
    
%     case_list = ["d00t25";"d00t35";"d00t45";"d00t55";
%         "d01t25";"d01t35";"d01t45";"d01t55";
%         "d02t25";"d02t35";"d02t45";"d02t55";
%         "d12t25";"d12t35";"d12t45";"d12t55"];
%     file_type = 'exp_10_10';
    m = 1;
    temp_list = ["t25", "t35", "t45", "t55"];
    case_list = strings(1, length(case_list_orig) * length(temp_list));
    for i = 1:1:length(case_list_orig)
        for j = 1:1:length(temp_list)
            case_list(m) = strcat(case_list_orig(i), temp_list(j));
            m = m + 1;
        end
    end
    frames = 63;
    
    data_all = cell(length(case_list), 21);
    for i = 1:1:length(case_list)
        data_all{i,1} = case_list(i);
        reg_input = strcat('DEm', case_list(i), r_mk, 'v20');
        data_exp = find_index(reg_input, file_list);
        len_data = length(data_exp{1,2}) - 1;
        for j = 1:1:len_data
            j_round = ceil(j/2)+1;
            n_j = j_round + rem(j+1, 2) * (len_data / 2); 
            one_data= combine_exp(data_exp{1,2}{j,1}, rem(j, 2), frames);
            data_all{i,n_j} = one_data .* rate_m;
%             one_data = combine_exp(data_exp{1,2}{j,1}, rem(j, 2), frames);
%             data_all{i,n_j} = normalize(-one_data, 'range');
        end
    end

    
%     save('Deform_1111.mat','data_all');
    
    data_notuse = 1;
    r_go = 10;
    r_back = 10;
    is_rand = 0;


    ori_data = data_all{1,2};
    deform_FEM = load(strcat(main_path, r_project, '\Matlab\AddNoise_10000_1000.mat'));
    deform_FEM = deform_FEM.fem_AddNoise;
%     此处 data_all已经筛选好了，只需要根据前40个更新矩阵即可
    d_d00t25 = cell2mat(deform_FEM{1,2});
    trans_mat = GetScaleMat(d_d00t25, data_all, UD_SCALE);
    
    % SCALE all
    data_all_t = data_all;
    for i = 1:1:size(data_all,1)
        for j = 2:1:size(data_all,2)
            data_all_t{i,j} = data_all{i,j} .*  -trans_mat;
        end
    end
    
    [sample_go, sample_back, type_go, type_back, sample_info] = dnoise2NN(data_all_t, r_go, r_back, data_notuse, is_rand, case_list_orig);
    
    file_route = strcat(main_path, r_project, '\Matlab\DataNeuNet\', r_date, '\', r_mk, '\');
    mkdir(strcat(file_route, file_type, "\", num2str(UD_SCALE)));
    file_name = strcat(file_route, file_type, "\", num2str(UD_SCALE), '\sample_go.mat');
    save(file_name, 'sample_go');
    file_name = strcat(file_route, file_type, "\", num2str(UD_SCALE), '\sample_back.mat');
    save(file_name, 'sample_back');
    file_name = strcat(file_route, file_type, "\", num2str(UD_SCALE), '\type_go.mat');
    save(file_name, 'type_go');
    file_name = strcat(file_route, file_type, "\", num2str(UD_SCALE), '\type_back.mat');
    save(file_name, 'type_back');
    file_name = strcat(file_route, file_type, "\", num2str(UD_SCALE), '\sample_info.mat');
    save(file_name, 'sample_info');
    
    
    
end

