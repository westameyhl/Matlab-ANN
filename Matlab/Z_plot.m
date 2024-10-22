function [] = Z_plot()
% plot
    
    addpath(genpath('funclist'));

%     file_list = ["elu", "relu", "softmax", "sigmoid"];
%     file_list_2 = ["ELU", "ReLU", "Softmax", "Sigmoid"];
%     i = 1;
%     for k = 1:1:4
%         file_name = strcat("E:\NeuralNW\3\Ep30_", file_list(k), "_Lr0.001_Hid3.csv");
%         data_file = readtable(file_name);
%         data_file = table2array(data_file);
%         i_fig = figure(1);
%         hold on;
%         title(strcat('Prediction Accuracy (', file_list_2(k), ')'));
%         xlabel('Epoch');
%         ylabel('Accuracy');
%         plot(data_file(:,7), data_file(:,8));
%         plot(data_file(:,7), data_file(:,9));
%         plot(data_file(:,7), data_file(:,10));
%         legend('test FEM','test Exp (vehicle same direction)','test Exp (vehicle opposite direction', 'Location','southeast')
%         set(gca,'xtick',[0 3 6 9 12 15 18 21 24 27 30])
%         set(gca,'xticklabel',{'0','3','6','9','12','15','18','21','24','27','30'})  
%         fig_name = strcat('E:\M2\meeting\General meeting\2\fig\',  file_list(k), '_acc.jpg');
%         saveas(i_fig, fig_name);
%         close(i_fig);
%         
%         i_fig = figure(2);
%         hold on;
%         title(strcat('MCE Loss (', file_list_2(k), ')'));
%         xlabel('Epoch');
%         ylabel('MCE Loss');
%         plot(data_file(2:end,7), data_file(2:end,3));
%         set(gca,'xtick',[0 3 6 9 12 15 18 21 24 27 30])
%         set(gca,'xticklabel',{'0','3','6','9','12','15','18','21','24','27','30'})  
%         fig_name = strcat('E:\M2\meeting\General meeting\2\fig\',  file_list(k), '_MCEloss.jpg');
%         saveas(i_fig, fig_name);
%         close(i_fig);
%     end

    file_list = ["Ep70_relu_Lr0.0002_Hid_test2_0011.csv", "Ep70_relu_Lr0.0002_Hid_test2_0101.csv", "Ep100_relu_Lr0.0002_Hid_test2_1110.csv"];
    file_list_2 = ["d02-d02d12", "d01-d01d12", "d00-d00d01d02"];
    file_route = "E:\Project_ExpNNFEM\P1\PyNN\";
    for i = 1:1:length(file_list)
        file_name = strcat(file_route, file_list(i));
        data_file = readtable(file_name);
        data_file = table2array(data_file);
        i_fig = figure(i);
        hold on;
        title(strcat('Prediction Accuracy (', file_list_2(i), ')'));
        xlabel('Epoch');
        ylabel('Accuracy');
        plot(data_file(:,7), data_file(:,8));
        plot(data_file(:,7), data_file(:,9));
        plot(data_file(:,7), data_file(:,10));
        legend('test FEM','test Exp (vehicle same direction)','test Exp (vehicle opposite direction', 'Location','southeast')
        [x_t, x_tb] = getXtick(data_file(:,7), 10);
        set(gca,'xtick',x_t)
        set(gca,'xticklabel',x_tb)  
        fig_name = strcat('E:\Project_ExpNNFEM\P1\Matlab\fig\',  file_list_2(i), '.jpg');
        saveas(i_fig, fig_name);
        close(i_fig);
    end

end

