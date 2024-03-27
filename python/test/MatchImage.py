import numpy as np

def match_img_test(rgb, trimap):
    F_threshold = 255 * 0.95
    B_threshold = 255 * 0.05


    F_mask = trimap >= F_threshold
    B_mask = trimap <= B_threshold


    F_mean = np.mean(rgb[F_mask], axis=0).reshape(1, -1)
    B_mean = np.mean(rgb[B_mask], axis=0).reshape(1, -1)
    print("shape of F_mask",F_mask.shape)
    print("shape of rgb",rgb.shape)
    print("shape of rgb[F_mask]",rgb[F_mask].shape)
    F_cov = np.cov(rgb[F_mask].T)

    B_cov = np.cov(rgb[B_mask].T)


    return F_mean, B_mean, F_cov, B_cov
