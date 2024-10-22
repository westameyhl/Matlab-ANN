function mat_output = op_convolution(mat_orig, mat_2, ratio_conv, trans_type)
% do convolutional operation
%   trans_type 1: convolutional operation
%   trans_type 2: inverse convolutional operation, get convolutional kernel


    mat_output = zeros(size(mat_orig,1)+1, size(mat_orig,2));
% t0= sum(mat_2)/sum(mat_orig)
%k0= mat_2 ./ mat_orig
    switch trans_type
%             case 1
%                 mat_output = zeros(size(mat_orig));
%                 for i = 1:1:size(mat_orig, 1)
%                     for j = 1:1:i
%                         mat_output(i,:) = mat_output(i,:) + mat_orig(i-j+1,:) .* mat_2(end-j+1,:);
%                     end
%                 end
%             case 2
%                 mat_output(end,:) = mat_2(1,:) ./ (mat_orig(1,:) + eps);
%                 for i = 2:1:size(mat_orig, 1)
%                     head_mat = mat_2(i,:);
%                     for j = 1:1:i-1
%                         head_mat = head_mat - mat_orig(i-j+1,:) .* mat_output(end-j+1,:);
%                     end
%                     mat_output(end-i+1,:) = head_mat ./ (mat_orig(1,:) + eps);
%                 end
        case 1
            mat_output = zeros(size(mat_orig));
            for i = 1:1:size(mat_orig, 1)
                mat_output(i,:) = mat_orig(i,:) .* mat_2(1,:);
                for j = 1:1:i
                    mat_output(i,:) = mat_output(i,:) + mat_orig(i,:) .* mat_2(i-j+2,:) * ratio_conv^(j-1);
                end
            end
        case 2
            mat_output(1,:) = sum(mat_2, 1) ./ sum(mat_orig,1);
            for i = 1:1:size(mat_orig, 1)
                head_mat = mat_2(i,:);
                for j = 1:1:i
                    head_mat = head_mat - mat_orig(i,:) .* mat_output(j,:) * ratio_conv^(j-1);
                end
                mat_output(i+1,:) = head_mat ./ (mat_orig(i,:) + eps);
            end
    end

end