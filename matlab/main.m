clc;
clear;
close all;
rgb_path = '/home/jiangmi/Documents/S2/CM/dataset/input_training_highres/GT01.png';
trimap_path = '/home/jiangmi/Documents/S2/CM/dataset/trimap_training_highres/Trimap1/GT01.png';
rgb = imread(rgb_path);
trimap = imread(trimap_path);
[F_rgb, B_rgb, U_rgb] = match_img(rgb, trimap);