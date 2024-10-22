function [mat_otp] = mat_6263(mat_inp, tp)
% tp = 1: 62 to 63
% tp = 2: 63 to 62

    switch tp
        case 1
            mat_otp = zeros(size(mat_inp, 1) + 1, size(mat_inp, 2));
            mat_otp(2:end,:) = mat_inp;
        case 2
            mat_otp = mat_inp(2:end,:);
    end
end