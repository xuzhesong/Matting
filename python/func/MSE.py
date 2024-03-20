import numpy as np
from skimage.color import rgb2gray

def MSE(Ip, Ir):
    if Ir.ndim == 3:
        Ir = rgb2gray(Ir)
    # Ensure Ip is also in grayscale if not already
    if Ip.ndim == 3:
        Ip = rgb2gray(Ip)
    mse = np.mean((Ir - Ip) ** 2)
    return mse
