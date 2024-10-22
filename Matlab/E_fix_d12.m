function [] = E_fix_d12(main_path, r_project, r_date, r_mk, UD_SCALE)


    addpath(strcat(main_path, 'MatData'));
    addpath(genpath('funclist'));
    data_all = {};
    
    
    file_route = strcat(main_path, r_project, '\Matlab\DataNeuNet\', r_date, '\', r_mk, '\');
    file_type = 'exp_0101';
   
    file_name = strcat(file_route, file_type, "\", num2str(UD_SCALE), '\type_go.mat');
    t = load(file_name);
    type_go = t.type_go;
    for i = 1:1:length(type_go)
        if type_go(i) == 1
            type_go(i) = 2;
        end
    end
    save(file_name, 'type_go');
    
    
    file_name = strcat(file_route, file_type, "\", num2str(UD_SCALE), '\type_back.mat');
    t = load(file_name);
    type_back = t.type_back;
    for i = 1:1:length(type_back)
        if type_back(i) == 1
            type_back(i) = 2;
        end
    end
    save(file_name, 'type_back');
    
    
    
end

