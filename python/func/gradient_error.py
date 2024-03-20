import numpy as np
from skimage.color import rgb2gray
from scipy.ndimage.filters import sobel

def gradient_error(Ip, Ir):
    if Ip.ndim == 3:
        Ip = rgb2gray(Ip)
    if Ir.ndim == 3:
        Ir = rgb2gray(Ir)
    
    # Calculate gradients using Sobel operator
    Gx_pred = sobel(Ip, axis=1)  # Gradient in X direction
    Gy_pred = sobel(Ip, axis=0)  # Gradient in Y direction
    Gx_true = sobel(Ir, axis=1)  # Gradient in X direction for true image
    Gy_true = sobel(Ir, axis=0)  # Gradient in Y direction for true image
    
    # Calculate the square of differences of gradients
    Gx_diff = (Gx_pred - Gx_true) ** 2
    Gy_diff = (Gy_pred - Gy_true) ** 2
    
    # Calculate the total gradient error and its average
    total_gradient_error = np.sqrt(Gx_diff + Gy_diff)
    gradient_error = np.mean(total_gradient_error)
    
    return gradient_error
