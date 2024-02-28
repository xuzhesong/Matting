function [F_mean, B_mean, F_cov, B_cov, F_mask, B_mask, U_mask] = match_img(rgb, trimap)
    F_mean = zeros(1,3);
    B_mean = zeros(1,3);
    F_cov = zeros(3,3);
    B_cov = zeros(3,3);
    % Initialize RGB output matrices with zeros
    F_rgb = zeros(size(rgb), 'like', rgb);
    B_rgb = zeros(size(rgb), 'like', rgb);
    U_rgb = zeros(size(rgb), 'like', rgb);

    % Define thresholds
    F_threshold = 255 * 0.95;
    B_threshold = 255 * 0.05;
    
    % Find foreground, background, and unknown pixels using logical indexing
    F_mask = trimap >= F_threshold;
    B_mask = trimap <= B_threshold;
    U_mask = ~F_mask & ~B_mask; % Unknown region is where it's neither F nor B
    % Convert logical masks to the same class as rgb for compatibility
    F_mask = uint8(F_mask); % Use uint8 or the appropriate class matching rgb
    B_mask = uint8(B_mask);
    NF = sum(F_mask(:) == 1);
    NB = sum(B_mask(:) == 1);
    
    % For each color channel, apply the masks
    for c = 1:3
        F_rgb(:,:,c) = rgb(:,:,c) .* F_mask;
        B_rgb(:,:,c) = rgb(:,:,c) .* B_mask;
        F_mean(c) = sum(sum(F_rgb(:,:,c))) / NF;
        B_mean(c) = sum(sum(B_rgb(:,:,c))) / NB;
    end

    for width = 1:size(rgb, 1)
        for height = 1:size(rgb, 2)
            if F_mask(width,height) == 1
                F_vec = squeeze(rgb(width, height, :));
                F_diff = double(F_vec) - double(F_mean');
                F_cov = F_cov + double(F_diff) * double(F_diff');
            end
            if B_mask(width,height) == 1
                B_vec = squeeze(rgb(width, height, :));
                B_diff = double(B_vec) - double(B_mean');
                B_cov = B_cov + double(B_diff) * double(B_diff');
            end
        end
    end
    F_cov = F_cov / NF;
    B_cov = B_cov / NB;
end