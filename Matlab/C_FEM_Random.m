function [] = C_FEM_Random(main_path, r_project, r_date)


    addpath(strcat(main_path, 'MatData'));
    addpath(genpath('funclist'));

    deform_FEM = load(strcat(main_path, 'MatData\DeformFEM', r_date, '.mat'));
    deform_FEM = deform_FEM.ALLDataFEM;
    deform_all = {};
%     reg_input = 'd\w{2}t\w{2}';
    reg_input = 'd0\w{1}t\w{2}';
    file_list = find_index(reg_input, deform_FEM, 4);
    
%     rate_FemExp = 3.5/2.9;
    rate_FemExp = 3.1/2.9;  
    n_train = 10000;
    n_test = 1000;
    
    n_total = n_train + n_test;
    fem_original_7 = get_data_7(file_list, 63);
    
%     for i = 1:1:length(fem_original_7)
%         fem_original_7{i,2} = normalize(-cell2mat(fem_original_7{i,2}), 'range');

    fem_AddNoise = AddNoise(fem_original_7, n_total, rate_FemExp);
%     [f, p1] = cal_fft(noise_567(1*10^4+1:10^5, 3),200);
%     plot(f(5:40),p1(5:40));
    data_notuse = 2;
    is_rand = 1;
    reg_list = ["d00", "d01", "d02", "d03", "d04"];
    [sample_train, sample_test, type_train, type_test, sample_info] = dnoise2NN(fem_AddNoise, n_train, n_test, data_notuse, is_rand, reg_list);
    
    file_route = strcat(main_path, r_project, '\Matlab\DataNeuNet\', r_date, '\');
    file_type = strcat('train_', num2str(n_train), '_test_', num2str(n_test));
    mkdir(strcat(file_route, file_type));
    file_name = strcat(file_route, file_type, '\sample_train.mat');
    save(file_name, 'sample_train');
    file_name = strcat(file_route, file_type, '\sample_test.mat');
    save(file_name, 'sample_test');
    file_name = strcat(file_route, file_type, '\type_train.mat');
    save(file_name, 'type_train');
    file_name = strcat(file_route, file_type, '\type_test.mat');
    save(file_name, 'type_test');
    file_name = strcat(file_route, file_type, '\sample_info.mat');
    save(file_name, 'sample_info');
    

     file_name = strcat('AddNoise_', num2str(n_train), '_', num2str(n_test), '.mat');
     save(file_name, 'fem_AddNoise');
end

