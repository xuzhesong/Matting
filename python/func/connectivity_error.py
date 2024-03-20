import numpy as np
from skimage.color import rgb2gray
from scipy.ndimage import label
from skimage.measure import regionprops

def ensure_gray_scale(img):
    if img.ndim == 3:
        img = rgb2gray(img)
    return img

def phi(alpha_values, lambda_, theta):
    Omega = 1
    d_values = np.abs(alpha_values - Omega)
    phi_values = 1 - lambda_ * (d_values >= theta) * d_values
    return phi_values

def calculate_lambda(alpha, source_domain, k):
    N = np.size(alpha)
    lambda_sum = 0
    source_domain_coords = np.argwhere(source_domain)
    
    for i in range(alpha.shape[0]):
        for j in range(alpha.shape[1]):
            if not source_domain[i, j]:
                distances = np.sqrt(np.sum((source_domain_coords - np.array([i, j]))**2, axis=1))
                dist_ij = np.min(distances)
                lambda_sum += dist_ij
                
    return lambda_sum / N

def calculate_source_domain(alpha_pred, alpha_true):
    common_area = alpha_pred & alpha_true
    labeled_array, num_features = label(common_area)
    if num_features == 0:
        return np.zeros_like(alpha_pred, dtype=bool)
    
    max_region = max(regionprops(labeled_array), key=lambda x: x.area)
    source_domain = np.zeros_like(alpha_pred, dtype=bool)
    source_domain[labeled_array == max_region.label] = True
    return source_domain

def connectivity_error(alpha, alpha_star, theta=0.15, p=1, k=0.15):
    alpha = ensure_gray_scale(alpha)
    alpha_star = ensure_gray_scale(alpha_star)
    
    source_domain = calculate_source_domain(alpha, alpha_star)
    lambda_ = calculate_lambda(alpha, source_domain, k)
    
    phi_alpha = phi(alpha, lambda_, theta)
    phi_alpha_star = phi(alpha_star, lambda_, theta)
    
    conn_error = np.sum(np.abs(phi_alpha - phi_alpha_star)**p) / np.size(alpha)
    return conn_error
