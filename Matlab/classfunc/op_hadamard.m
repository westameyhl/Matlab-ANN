function [mat_output] = op_hadamard(mat_orig, mat_2, trans_type)
% do convolutional operation
%   trans_type 1: convolutional operation
%   trans_type 2: inverse convolutional operation, get convolutional kernel

    if size(mat_orig, 1)==size(mat_2, 1) && size(mat_orig, 2)==size(mat_2, 2)
        mat_output = zeros(size(mat_orig));

        switch trans_type
            case 1
                mat_output = mat_orig .* mat_2;
            case 2
                mat_output = mat_2 ./ (mat_orig + eps);
        end
    else 
        disp("matrix size unmatched")
    end

end