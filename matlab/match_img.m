% function [F_rgb, B_rgb, U_rgb] = match_img(rgb, trimap)
%     F_threshold = 255 * 0.9;
%     B_threshold = 255 * 0.0;
%     width = size(rgb,1);
%     heigth = size(rgb,2);
%     for w = 1 : width
%         for h = 1 : heigth
%             if trimap(w, h) >= F_threshold
%                 F_rgb(w, h, 1) = rgb(w, h, 1);
%                 F_rgb(w, h, 2) = rgb(w, h, 2);
%                 F_rgb(w, h, 3) = rgb(w, h, 3);
%             elseif trimap(w, h) <= B_threshold
%                 B_rgb(w, h, 1) = rgb(w, h, 1);
%                 B_rgb(w, h, 2) = rgb(w, h, 2);
%                 B_rgb(w, h, 3) = rgb(w, h, 3);
%             else
%                 U_rgb(w, h, 1) = rgb(w, h, 1);
%                 U_rgb(w, h, 2) = rgb(w, h, 2);
%                 U_rgb(w, h, 3) = rgb(w, h, 3);
%             end
%         end
%     end

function [F_rgb, B_rgb, U_rgb] = match_img(rgb, trimap)
    % Initialize RGB output matrices with zeros
    F_rgb = zeros(size(rgb), 'like', rgb);
    B_rgb = zeros(size(rgb), 'like', rgb);
    U_rgb = zeros(size(rgb), 'like', rgb);

    % Define thresholds
    F_threshold = 255 * 0.9;
    B_threshold = 255 * 0.0;
    
    % Find foreground, background, and unknown pixels using logical indexing
    F_mask = trimap >= F_threshold;
    B_mask = trimap <= B_threshold;
    U_mask = ~F_mask & ~B_mask; % Unknown region is where it's neither F nor B

    % Convert logical masks to the same class as rgb for compatibility
    F_mask = uint8(F_mask); % Use uint8 or the appropriate class matching rgb
    B_mask = uint8(B_mask);
    U_mask = uint8(U_mask);
    
    % For each color channel, apply the masks
    for c = 1:3
        F_rgb(:,:,c) = rgb(:,:,c) .* F_mask;
        B_rgb(:,:,c) = rgb(:,:,c) .* B_mask;
        U_rgb(:,:,c) = rgb(:,:,c) .* U_mask;
    end
    imshow([F_rgb B_rgb U_rgb])
end