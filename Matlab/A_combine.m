function [] = A_combine()

    clear;
    clc;

    % addpath('C:\westame\Matlab\data');
    % addpath(genpath('funclist'));
    addpath('E:\Matlab\Data');
    addpath(genpath('funclist'));

    % deform_data = load('C:\westame\Matlab\data\DispData.mat');
    deform_data = load('E:\Matlab\Data\DispData.mat');
    deform_data = deform_data.DispData;
    deform_FEM = load('E:\Matlab\Data\DeformFEM0509.mat');
    deform_FEM = deform_FEM.ALLDataFEM;
    deform_all = {};
    
    reg_input = 'DEm\w{6}m2k1v20';
    file_list = find_index(reg_input, deform_data);
    
    for i = 1:1:16
        i_case = deform_FEM{i,1}{1,1};
         deform_all{i,1} = i_case;
         deform_orig = cell2mat(deform_FEM{i,3}(2:end,2:8));
         deform_all{i,2} = deform_orig - deform_orig(1,:);
         i_time_list = cell2mat(deform_FEM{i,3}(2:end,1));
         deform_all{i,3} = get32points(file_list, i_case, i_time_list);
    end
    
    save('DeformCompareVer01.mat','deform_all');
    
end

