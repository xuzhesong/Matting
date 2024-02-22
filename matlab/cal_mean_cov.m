function [means, cov] = cal_mean_cov(match_img)
    means = zeros(1,3);
    for ch = 1 : 3
        single_channal = match_img(:,:,ch);
        nonzero = single_channal(single_channal > 0);
        num_pixel = length(nonzero);
        means(ch) = mean(nonzero);
    end
    cov = [0,0,0;0,0,0;0,0,0];
    for width = 1:size(match_img, 1)
        for height = 1:size(match_img, 2)
            if sum(match_img(width, height, :)) ~= 0
                vec = squeeze(match_img(width, height, :));
                cov = cov + double(vec) * double(vec');
            end
        end
    end
    cov = cov / num_pixel;
end