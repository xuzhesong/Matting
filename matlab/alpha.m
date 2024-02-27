<<<<<<< HEAD
% Function to compute alpha matte
function alpha_matte = compute_alpha_matte(U_rgb, F_mean, F_covariance, B_mean, B_covariance)
    [height, width, ~] = size(U_rgb);
    alpha_matte = zeros(height, width);
    % Define the iteration parameter
    Iteration = 10;
    % Define the original variance 
    oriVar = 8;
    
    for h = 1:height
        for w = 1:width
            if nnz(U_rgb(h, w, :)) > 0
                % Initialize alpha to some initial value
                alpha = 0.5; % You can use any reasonable initial value
                
                % Iterate to refine alpha
                for iter = 1:Iteration
                    % Compute the terms needed for the linear system
                    UL = F_covariance + eye(3)*(alpha^2)/(oriVar^2);
                    UR = eye(3)*alpha*(1-alpha)/(oriVar^2);
                    DL = eye(3)*alpha*(1-alpha)/(oriVar^2);
                    DR = B_covariance + eye(3)*((1-alpha)^2)/(oriVar^2);
                    
                    % Construct the coefficient matrix A and the right-hand side vector B
                    A = [UL, UR; DL, DR];
                    C = reshape(U_rgb(h, w, :), 3, 1);
                    BU = F_covariance * F_mean' + C * alpha/(oriVar^2);
                    BD = B_covariance * B_mean' + C * (1-alpha)/(oriVar^2);
                    B = [BU; BD];
                    
                    % Solve the linear system to find the new alpha
                    x = A \ B;
                    tempF = x(1:3);
                    tempB = x(4:6);
                    alpha = dot((C - tempB), (tempF - tempB)) / norm(tempF - tempB)^2;
                end
                
                % Update alpha_matte with the final alpha value
                alpha_matte(h, w) = alpha;
                unknownAlpha = compute_alpha_matte(U_rgb, F_mean, F_covariance, B_mean, B_covariance);
                imshow(uint8(unknownAlpha));
=======
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
>>>>>>> 10325cc981b91bb7de4a10cabbc6b4ce93385966
