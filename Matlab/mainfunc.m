clc;
clear;


% main_path  = 'E:\Project_ExpNNFEM\';
main_path  = 'C:\westame\Project_ExpNNFEM\';
r_project = 'P6';
r_date = '0715';
r_mk_list = "m2k1";
% r_mk_list = ["m1k1", 'm3k1'];
% r_mk = 'm2k1';
% pyversion('C:\Program Files\Python39\python.exe');
addpath(genpath('Class'));
addpath(genpath('classfunc'));

% C_FEM_Random(main_path, r_project, r_date);

for i_mk = 1:1:length(r_mk_list)

    case_list = ["d00", "d01", "d02"];
    for i_scale = 1:1:40
        file_type = 'exp_1110';
        ADG = AnnDataGererator(case_list, file_type, main_path, r_project, r_date, r_mk_list(i_mk), i_scale);
        ADG.combine_exp();
        ADG.scale_all(2, 0.05);
        ADG.dnoise2NN();
        ADG.save_data();
    %     pyrunfile('C:\westame\Project_ExpNNFEM\P3\PyNN\fem_NN_all.py');
        disp(strcat("case:", r_mk_list(i_mk), "  upd:", num2str(i_scale)))
    end
    
end
    

format longG
t = now;
d = datetime(t,'ConvertFrom','datenum');
disp(d)
% case_list = ["d01", "d12"];
% file_type = 'exp_0101';
% D_EXP_62s(case_list, file_type, main_path, r_project, r_date);
% case_list = ["d02", "d12"];
% file_type = 'exp_0011';
% D_EXP_62s(case_list, file_type, main_path, r_project, r_date);




% pyrunfile('C:\westame\Project_ExpNNFEM\P3\PyNN\fem_NN_p.py')
% pyrunfile('C:\westame\Project_ExpNNFEM\P3\Matlab\test.py')
