function [max_list, max_location, N] = identify_max(data_wave, delta_t, y_accuracy_rate)
    % get all max point of wave function
    % [max_list, max_location, N] = identify_max(data_wave, delta_t, y_accuracy)
    
    x_accuracy = 5 * delta_t;
    y_accuracy = y_accuracy_rate * max(data_wave);
    
    sz_m = size(data_wave);
    max_list = zeros(sz_m);
    max_location = zeros(sz_m);
    loop_end = length(data_wave) - 1;

    k_location = 0;
    for i = 2:1:loop_end
        if ((data_wave(i) > data_wave(i-1)) && (data_wave(i) < data_wave(i+1)))
            k_location = k_location + 1;
            max_list(k_location) = data_wave(i);
            max_location(k_location) = i;  
        end
        if k_location > 1
            if max_location(k_location) < y_accuracy
                break;
            end
            if max_location(k_location) - max_location(k_location-1) < x_accuracy
                k_location = k_location - 1;
            end
        end
    end 

    max_location = max_location(1:k_location-1);
    max_list = max_list(1:k_location-1);
    N = length(max_list);

    if N < 2
        disp('Only one sample collected !')
    elseif N < 4
        disp('WARNING: Number of sample less than 4 !')
    end

end