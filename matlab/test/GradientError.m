function gradientError = GradientError(Ip, Ir)
    % 确保输入图像是灰度图
    if size(Ip, 3) == 3
        Ip = rgb2gray(Ip);
    end
    
    if size(Ir, 3) == 3
        Ir = rgb2gray(Ir);
    end
    
    % calculate gradient
    [Gx_pred, Gy_pred] = imgradientxy(Ip, 'sobel');
    [Gx_true, Gy_true] = imgradientxy(Ir, 'sobel');
    
    % calculate the power of differece of gradient
    Gx_diff = (Gx_pred - Gx_true).^2;
    Gy_diff = (Gy_pred - Gy_true).^2;
    
    % add x and y togther and doing square operation
    totalGradientError = sqrt(Gx_diff + Gy_diff);
    
    % calculate average gradient error
    gradientError = mean(totalGradientError(:));
end
