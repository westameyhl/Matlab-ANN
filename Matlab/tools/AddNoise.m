function fem_AddNoise = AddNoise(fem_original_7, n_test, rate_noise)


    fem_AddNoise = fem_original_7;
    for i = 1:1:length(fem_original_7)
        for j = 1:1:n_test
            fem_AddNoise{i,j+2} = AddNoise_one(-fem_original_7{i,2}, rate_noise);
        end
    end

end

