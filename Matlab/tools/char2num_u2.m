function data_num = char2num_u2(data_chr)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

%     data_chr = 'PART-1-1      101018           67487    -33.3571E-03';
    for i = 1:1:length(data_chr)
        if strcmp(data_chr(end-i+1),'E')
            i_sci = length(data_chr)-i+1;
        end
        if strcmp(data_chr(end-i+1),' ')
            break;
        end
    end
    data_num_1 = str2num(data_chr(end-i+2:i_sci-1));
    data_num_2 = str2num(data_chr(i_sci+1:end));
    data_num = data_num_1 * 10^(data_num_2);

end

