import numpy as np

def match_img(rgb, trimap):
    # Initialize means and covariances
    F_mean = np.zeros((1, 3))
    B_mean = np.zeros((1, 3))
    F_cov = np.zeros((3, 3))
    B_cov = np.zeros((3, 3))

    # Initialize RGB output matrices with zeros, matching the type of `rgb`
    F_rgb = np.zeros_like(rgb)
    B_rgb = np.zeros_like(rgb)
    U_rgb = np.zeros_like(rgb)

    # Define thresholds
    F_threshold = 255 * 0.95
    B_threshold = 255 * 0.05

    # Find foreground, background, and unknown pixels using logical indexing
    F_mask = trimap >= F_threshold
    B_mask = trimap <= B_threshold
    U_mask = ~F_mask & ~B_mask  # Unknown region is where it's neither F nor B

    # Convert logical masks to uint8 for compatibility (if needed)
    F_mask = F_mask.astype(np.uint8)
    B_mask = B_mask.astype(np.uint8)
    NF = np.sum(F_mask == 1)
    NB = np.sum(B_mask == 1)
    
    # For each color channel, apply the masks and calculate means
    for c in range(3):
        F_rgb[:, :, c] = rgb[:, :, c] * F_mask
        B_rgb[:, :, c] = rgb[:, :, c] * B_mask
        F_mean[0, c] = np.sum(F_rgb[:, :, c]) / NF
        B_mean[0, c] = np.sum(B_rgb[:, :, c]) / NB

    # Calculate covariance matrices for F and B
    for width in range(rgb.shape[0]):
        for height in range(rgb.shape[1]):
            if F_mask[width, height] == 1:
                F_vec = rgb[width, height, :]
                F_diff = F_vec - F_mean
                F_cov += np.dot(F_diff.T, F_diff)
            if B_mask[width, height] == 1:
                B_vec = rgb[width, height, :]
                B_diff = B_vec - B_mean
                B_cov += np.dot(B_diff.T, B_diff)

    F_cov = F_cov / NF
    B_cov = B_cov / NB

    return F_mean, B_mean, F_cov, B_cov
