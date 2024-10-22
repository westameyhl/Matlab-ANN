classdef ScalingTools < handle
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here

    properties
        mat_target;
        data_orig;
        UD_scale;
        trans_mat;
        ratio_conv;
    end

    methods
        function obj = ScalingTools(mat_target, data_orig, UD_scale, ratio_conv)
            %UNTITLED3 Construct an instance of this class
            %   Detailed explanation goes here
            obj.mat_target = mat_target;
            obj.data_orig = data_orig;
            obj.UD_scale = UD_scale;
            obj.ratio_conv = ratio_conv;
        end

        function data_all_t = sm_hadamard(obj)
            mat_exp = get_initial(obj.data_orig, obj.UD_scale);
            obj.trans_mat = op_hadamard(mat_exp, obj.data_orig, 2);
            data_all_t = obj.data_orig;
            for i = 1:1:size(obj.data_orig,1)
                for j = 2:1:size(obj.data_orig,2)
                    data_all_t{i,j} = op_hadamard(obj.data_orig{i,j}, obj.trans_mat, 1);
                end
            end
        end

        function data_all_t = sm_convolution(obj)
            mat_exp = get_initial(obj.data_orig, obj.UD_scale);
            obj.trans_mat = op_convolution(mat_exp, obj.mat_target, obj.ratio_conv, 2);
            data_all_t = obj.data_orig;
            for i = 1:1:size(obj.data_orig,1)
                for j = 2:1:size(obj.data_orig,2)
                    data_all_t{i,j} = op_convolution(obj.data_orig{i,j}, obj.trans_mat, obj.ratio_conv, 1);
                end
            end
        end

        function data_all_t = sm_selfecoder(obj)
            mat_exp = get_initial(obj.data_orig, obj.UD_scale);
            obj.trans_mat = op_convolution(mat_exp, obj.mat_target, obj.ratio_conv, 2);
            data_all_t = obj.data_orig;
            for i = 1:1:size(obj.data_orig,1)
                for j = 2:1:size(obj.data_orig,2)
                    data_all_t{i,j} = op_ecoder(obj.data_orig{i,j}, obj.trans_mat, obj.ratio_conv, 1);
                end
            end
        end
    end
end