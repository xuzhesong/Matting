function conn_error = ConnectivityError(alpha, alpha_star)
    theta = 0.15;
    p = 1;
    k = 0.15;
    % if rgb transform to grey
    alpha = ensureGrayScale(alpha);
    alpha_star = ensureGrayScale(alpha_star);

    % calculate source domain
    source_domain = calculate_source_domain(alpha, alpha_star);

    % calculate lambda
    lambda = calculate_lambda(alpha, source_domain, k);
    
    % calculate phi function
    phi_alpha = phi(alpha, lambda, theta);
    phi_alpha_star = phi(alpha_star, lambda, theta);
    
    % calculate Connectivity Error
    conn_error = sum(abs(phi_alpha(:) - phi_alpha_star(:)).^p) / numel(alpha);

    
    function img = ensureGrayScale(img)
        if ndims(img) == 3
            img = rgb2gray(img);
        end
    end

    function phi_values = phi(alpha_values, lambda, theta)
        Omega = 1; 
        d_values = abs(alpha_values - Omega); 
        phi_values = 1 - lambda * (d_values >= theta) .* d_values; 
    end

    function lambda = calculate_lambda(alpha, source_domain, k)
    N = numel(alpha); 
    [rows, cols] = find(source_domain); 
    source_domain_coords = [rows, cols]; 
    lambda_sum = 0;
    
    parfor i = 1:numel(alpha)
        [row, col] = ind2sub(size(alpha), i);
        if source_domain(row, col)
            continue;
        else
            % distances
            distances = sqrt(sum((source_domain_coords - [row, col]).^2, 2));
            dist_ij = min(distances);
            lambda_sum = lambda_sum + dist_ij;
        end
    end
    
    lambda = lambda_sum / N; % normalize lambda
end


    function source_domain = calculate_source_domain(alpha_pred, alpha_true)
        common_area = alpha_pred & alpha_true; % public area
        CC = bwconncomp(common_area); % find connective area
        numPixels = cellfun(@numel, CC.PixelIdxList); % number of pixels
        [~, idx] = max(numPixels); % find maximum connective area
        source_domain = false(size(alpha_pred)); % initilize connective area
        source_domain(CC.PixelIdxList{idx}) = true; % set max connective area to source domain
    end
end
