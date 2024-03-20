import numpy as np
from skimage.color import rgb2gray

def SAD(Ip, Ir):
    if Ip.ndim == 3:
        Ip = rgb2gray(Ip)
    if Ir.ndim == 3:
        Ir = rgb2gray(Ir)
    sad = np.sum(np.abs(Ir - Ip))
    return sad
