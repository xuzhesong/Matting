function alpha = calculate_alpha(rgb_path, trimap_path, Var, n)
    rgb = imread(rgb_path); % Read RGB image
    trimap = imread(trimap_path); % Read trimap
    image = double(rgb); % Convert RGB image to double
    Alpha = double(trimap / 255); % Convert trimap to double and normalize
    
    [meanF, meanB, F_cov, B_cov] = match_img(rgb, trimap);
    F_cov_inv = inv(F_cov); % Invert foreground covariance matrix
    B_cov_inv = inv(B_cov); % Invert background covariance matrix
    
    column = size(rgb, 1); % Get number of columns
    row = size(rgb, 2); % Get number of rows
    kernel = ones(3,3) / 9;
    I = eye(3);

    for b = 1 : row
        for a = 1 : column
            if trimap(a, b) > 0 && trimap(a, b) < 255 % Check for unknown region
                alpha_map = conv2(Alpha, kernel, "same"); % Smooth alpha values
                alpha = alpha_map(a, b); % Initial alpha value from smoothed map
                
                for i = 1 : 1 : n % Iterative refinement loop
                    C = reshape(image(a, b, :), 3, 1); % Current pixel color
                    
                    % Compute matrices
                    a11 = F_cov_inv + I * alpha^2 / Var^2;
                    a12 = I * alpha * (1-alpha) / Var^2;
                    a21 = I * alpha * (1-alpha) / Var^2;
                    a22 = B_cov_inv + I * (1 - alpha)^2 / Var^2;
                    
                    b1 = F_cov_inv * meanF' + C * alpha / (Var^2);
                    b2 = B_cov_inv * meanB' + C * (1 - alpha) / (Var^2);
                    
                    A = [a11 a12; a21 a22];
                    B = [b1; b2];
                    
                    FB = A\B;
                    iterF = FB(1:3); % Foreground color
                    iterB = FB(4:6); % Background color
                    alpha = dot((C - iterB), (iterF - iterB)) / norm(iterF - iterB) .^ 2; % Update alpha
                end
                Alpha(a, b) = alpha;
            end
        end 
    end
    alpha = Alpha;
end