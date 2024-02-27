clc;
clear;
close all;

rgb_path = 'GT01[1].png';
trimap_path = 'GT01_trimap.png';
rgb = imread(rgb_path);
trimap = imread(trimap_path);

alpha = bayesian_matting(rgb, trimap);

% Display the result
imshow(alpha);

function alpha = bayesian_matting(rgb, trimap)
    % Convert RGB image and trimap to double precision
    rgb = im2double(rgb);
    trimap = im2double(trimap);

    % Get dimensions
    [rows, cols, ~] = size(rgb);
    
    % Initialize alpha matte
    alpha = zeros(rows, cols);

    % Iterate over each pixel
    for i = 1:rows
        for j = 1:cols
            % If the pixel is unknown
            if trimap(i, j) > 0 && trimap(i, j) < 1
                % Get the RGB values of the pixel
                pixel_rgb = reshape(rgb(i, j, :), [], 3);
                
                % Calculate alpha using Bayesian matting equation
                alpha(i, j) = (pixel_rgb * (pixel_rgb') - pixel_rgb * (pinv(cov(pixel_rgb)) * pixel_rgb') + (1 - pixel_rgb) * (pinv(cov(1 - pixel_rgb)) * (1 - pixel_rgb)')) / 2;
            else
                % If the pixel is known, copy trimap value
                alpha(i, j) = trimap(i, j);
            end
        end
    end
end
