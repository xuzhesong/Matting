import os
import numpy as np
from glob import glob
import cv2
from func import calculate_alpha

def process_folder(rgb_folder, trimap_folder, output_folder, scale=8, threshold=1):
    # 确保输出文件夹存在
    os.makedirs(output_folder, exist_ok=True)

    # 获取RGB图像文件列表
    rgb_images = glob(os.path.join(rgb_folder, '*.png'))

    for rgb_path in rgb_images:
        # 为trimap构建路径，假设trimap和RGB图像文件名匹配
        trimap_path = os.path.join(trimap_folder, os.path.basename(rgb_path))
        
        # 检查trimap文件是否存在
        if not os.path.exists(trimap_path):
            print(f"Trimap for {rgb_path} not found. Skipping...")
            continue
        
        # 使用calculate_alpha计算alpha matte
        alpha_bayesian = calculate_alpha.calculate_alpha(rgb_path, trimap_path, scale, threshold)
        alpha_bayesian = (alpha_bayesian > 0.5).astype(np.uint8)
        
        # 构建输出路径并保存alpha matte
        output_path = os.path.join(output_folder, os.path.basename(rgb_path).replace('_image', '_alpha'))
        cv2.imwrite(output_path, alpha_bayesian * 255)
        # 或者如果使用PIL: Image.fromarray((alpha_bayesian * 255).astype(np.uint8)).save(output_path)

# 调用函数
process_folder('/home/jiangmi/Documents/S2/CM/Matting/dataset/input_training_lowres', '/home/jiangmi/Documents/S2/CM/Matting/dataset/trimap_training_lowres/Trimap1', '/home/jiangmi/Documents/S2/output')
