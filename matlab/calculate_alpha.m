
function alpha = calculate_alpha(rgb_path, trimap_path, Var, n)
    rgb = imread(rgb_path);
    trimap = imread(trimap_path);
    image = double(rgb);
    Alpha = double(trimap / 255);
    [meanF, meanB, F_cov, B_cov] = match_img(rgb, trimap);
    F_cov_inv = inv(F_cov);
    B_cov_inv = inv(B_cov);
    column = size(rgb, 1);
    row = size(rgb, 2);
    kernel = ones(3,3) / 9;
    I = eye(3);
    for b = 1 : row
        for a = 1 : column
            if trimap(a, b) > 0 && trimap(a, b) < 255
                alpha_map = conv2(Alpha, kernel, "same");
                alpha = alpha_map(a, b);
                
                for i = 1 : 1 : n
                    C = reshape(image(a, b, :), 3, 1);
                    
                    a11 = F_cov_inv + I * alpha^2 / Var^2;
                    a12 = I * alpha * (1-alpha) / Var^2;
                    a21 = I * alpha * (1-alpha) / Var^2;
                    a22 = B_cov_inv + I * (1 - alpha)^2 / Var^2;
                    
                    b1 = F_cov_inv * meanF' + C * alpha / (Var^2);
                    b2 = B_cov_inv * meanB' + C * (1 - alpha) / (Var^2);
                    
                    A = [a11 a12; a21 a22];
                    B = [b1; b2];
                    
                    FB = A\B;
                    iterF = FB(1:3); 
                    iterB = FB(4:6);
                    alpha = dot((C - iterB), (iterF - iterB)) / norm(iterF - iterB) .^ 2;
                end
                Alpha(a, b) = alpha;
            end
        end 
    end
    alpha = Alpha;
end
