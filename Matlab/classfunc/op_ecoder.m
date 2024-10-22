function mat_output = op_ecoder(mat_orig, mat_2, trans_type)
% do convolutional operation
%   trans_type 1: decode
%   trans_type 2: ecode

    w1=0.1;
    w2=0.9;
    w3=0.05;
    mat_output = zeros(size(mat_orig));
    mat_mid = zeros(size(mat_orig));
% t0= sum(mat_2)/sum(mat_orig)
%k0= mat_2 ./ mat_orig
    switch trans_type
        case 1
            for i = 1:1:size(mat_orig, 1)
                for j = 1:1:size(mat_orig, 2)
                    if i == 1
                        mat_mid(i,j) = mat_orig(i,j)*w2 + mat_orig(i+1,j)*w3;
                    elseif i == size(mat_orig, 1)
                        mat_mid(i,j) = mat_orig(i-1,j)*w1 + mat_orig(i,j)*w2;
                    else
                        mat_mid(i,j) = mat_orig(i-1,j)*w1 + mat_orig(i,j)*w2 + mat_orig(i+1,j)*w3;
                    end
                    mat_output(i,j) = mat_mid(i,j) .* mat_2(i,j);
                end
            end
        case 2
            for i = 1:1:size(mat_orig, 1)
                for j = 1:1:size(mat_orig, 2)
                    if i == 1
                        mat_mid(i,j) = mat_orig(i,j)*w2 + mat_orig(i+1,j)*w3;
                    elseif i == size(mat_orig, 1)
                        mat_mid(i,j) = mat_orig(i-1,j)*w1 + mat_orig(i,j)*w2;
                    else
                        mat_mid(i,j) = mat_orig(i-1,j)*w1 + mat_orig(i,j)*w2 + mat_orig(i+1,j)*w3;
                    end
                    mat_output(i,j) = mat_2(i,j) ./ mat_mid(i,j);
                end
            end
    end

end