import numpy as np
from PIL import Image
import matplotlib.pyplot as plt
from time import time
from skimage.color import rgb2gray
from func import calculate_alpha
from func import evaluation

# Load images
rgb_path = 'test/GT08_image.png'
trimap_path = 'test/GT08_trimap.png'
rgb = np.array(Image.open(rgb_path))
trimap = np.array(Image.open(trimap_path))

# Calculate alpha matte
start_time = time()
alpha_bayasion = calculate_alpha.calculate_alpha(rgb_path, trimap_path, 8, 10)
print(f"Elapsed time: {time() - start_time} seconds")

# Binarize alpha
alpha_bayasion = (alpha_bayasion > 0.5).astype(np.uint8)

# Foreground and background calculation
F = np.zeros_like(rgb, dtype=float)
B = np.zeros_like(rgb, dtype=float)
for c in range(3):  # Iterate over RGB channels
    F[:, :, c] = alpha_bayasion * rgb[:, :, c]
    B[:, :, c] = (1 - alpha_bayasion) * rgb[:, :, c]

# Load ground truth alpha matte
gt = np.array(Image.open("./test/GT08.png"))
[MSE_value, SAD_value, gradient_error_value] = evaluation.evaluation(alpha_bayasion, gt)

header = "| Metric                     | Value   |"
divider = "+" + "-"*28 + "+" + "-"*9 + "+"
print(divider)
print(header)
print(divider)
print(f"| MSE (Mean Squared Error)   | {MSE_value:.4f}  |")
print(f"| SAD (Sum of Absolute Diff) | {SAD_value:.2f}|")
print(f"| Gradient Error             | {gradient_error_value:.4f}  |")
print(divider)

# Plotting
fig, axs = plt.subplots(3, 2, figsize=(10, 15))
axs[0, 0].imshow(rgb)
axs[0, 0].set_title('RGB')
axs[0, 1].imshow(trimap)
axs[0, 1].set_title('Trimap')
axs[1, 0].imshow(gt, cmap='gray')
axs[1, 0].set_title('Ground Truth')
axs[1, 1].imshow(alpha_bayasion, cmap='gray')
axs[1, 1].set_title('Alpha Matte')
axs[2, 0].imshow(F.astype(np.uint8))
axs[2, 0].set_title('Foreground')
axs[2, 1].imshow(B.astype(np.uint8))
axs[2, 1].set_title('Background')

for ax in axs.flat:
    ax.axis('off')

plt.tight_layout()
plt.show()
