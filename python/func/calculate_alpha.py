import numpy as np
from scipy.signal import convolve2d
from PIL import Image
from numpy.linalg import inv
from func import match_img
import tqdm

def calculate_alpha(rgb_path, trimap_path, Var, n):
    # Read RGB and trimap images
    rgb = np.array(Image.open(rgb_path))
    trimap = np.array(Image.open(trimap_path))

    # Convert images to double precision and normalize trimap
    image = rgb.astype(float)
    Alpha = trimap.astype(float) / 255

    # Assuming match_img is properly defined and imported
    meanF, meanB, F_cov, B_cov = match_img.match_img(rgb, trimap)
    F_cov_inv = inv(F_cov)
    B_cov_inv = inv(B_cov)

    column, row = rgb.shape[:2]
    kernel = np.ones((3, 3)) / 9
    I = np.eye(3)
    alpha_map = convolve2d(Alpha, kernel, mode="same")  # Move outside the loop

    for b in tqdm.tqdm(range(row)):
        for a in range(column):
            if 0 < trimap[a, b] < 255:  # Only in unknown region
                alpha = alpha_map[a, b]  # Use precomputed smoothed value

                for i in range(n):  # Iterative refinement loop
                    C = image[a, b, :].reshape(3, 1)  # Current pixel color

                    # Compute matrices once, reuse them
                    a11 = F_cov_inv + I * alpha**2 / Var**2
                    a12 = I * alpha * (1 - alpha) / Var**2
                    a21 = I * alpha * (1 - alpha) / Var**2
                    a22 = B_cov_inv + I * (1 - alpha)**2 / Var**2

                    b1 = F_cov_inv @ meanF.reshape(3, 1) + C * alpha / Var**2
                    b2 = B_cov_inv @ meanB.reshape(3, 1) + C * (1 - alpha) / Var**2

                    A = np.block([[a11, a12], [a21, a22]])
                    B = np.vstack((b1, b2))

                    FB = np.linalg.solve(A, B)
                    iterF = FB[:3]  # Foreground color
                    iterB = FB[3:]  # Background color
                    alpha = np.dot((C - iterB).flatten(), (iterF - iterB).flatten()) / np.linalg.norm(iterF - iterB)**2

                Alpha[a, b] = alpha

    return Alpha
