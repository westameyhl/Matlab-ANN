function [] = B_compare()

    clear;
    clc;

    % addpath('C:\westame\Matlab\data');
    % addpath(genpath('funclist'));
    addpath('E:\Matlab\Data');
    addpath(genpath('funclist'));

    % deform_data = load('C:\westame\Matlab\data\DispData.mat');
    deform_data = load('DeformCompareVer01.mat');
    deform_data = deform_data.deform_all;
    deform_comp = deform_data;
    
    rc = [17, 4];
    direct_v = 2;
    
    for m = 1:1:16
        for n = 1:1:10
            measure_list_1(n) = deform_comp{m,3}{n,direct_v}(rc(1),rc(2));
        end
        n_rate = mean(measure_list_1)/deform_comp{m,2}(rc(1),rc(2));
        deform_comp{m,4} = deform_comp{m,2} * n_rate;
    end
    
    for i = 1:1:16
        data_0 = deform_comp{i,4};
        for j = 1:1:10
            data_j = deform_data{i,3}{j,direct_v};
            result_1 = compare_all(data_0, data_j);
            deform_comp{i,5}(j,1) = result_1;
        end
    end
    
    % test part
%     data_0 = deform_comp{5,4};
%     data_j = deform_data{5,3}{3,direct_v};
%     result_1 = compare_all(data_0, data_j);
    comp_form = {};
    comp_form(2:17,1) = deform_comp(1:16,1);
    comp_form(1,2:17) = deform_comp(1:16,1)';
    select_loop = 7;
    for i = 5:1:16
        i_data = deform_comp{i,4};
        for j = 5:1:16
            j_data = deform_comp{j,3}{select_loop,direct_v};
            ij_result = compare_all(i_data, j_data);
            comp_form{i+1,j+1} = ij_result;
        end
    end
    f_name = 'ActFem.csv';
    writecell(comp_form, f_name)
    
    comp_form = {};
    comp_form(2:17,1) = deform_comp(1:16,1);
    comp_form(1,2:17) = deform_comp(1:16,1)';
    select_loop = 7;
    for i = 5:1:16
        i_data = deform_comp{i,4};
        for j = 5:1:16
            j_data = deform_comp{j,4};
            ij_result = compare_all(i_data, j_data);
            comp_form{i+1,j+1} = ij_result;
        end
    end
    f_name = 'FemFem.csv';
    writecell(comp_form, f_name)

    comp_form = {};
    comp_form(2:17,1) = deform_comp(1:16,1);
    comp_form(1,2:17) = deform_comp(1:16,1)';
    select_loop = 7;
    for i = 5:1:16
        i_data = deform_comp{i,3}{select_loop,direct_v};
        for j = 5:1:16
            j_data = deform_comp{j,3}{select_loop,direct_v};
            ij_result = compare_all(i_data, j_data);
            comp_form{i+1,j+1} = ij_result;
        end
    end
    f_name = 'ActAct.csv';
    writecell(comp_form, f_name)

    save('DeformCompareVer02.mat','deform_comp');
    
end

