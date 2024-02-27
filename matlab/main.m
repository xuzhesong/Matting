clc;
clear;
close all;

rgb_path = 'GT01_image.png';
trimap_path = 'GT01_trimap.png';
rgb = imread(rgb_path);
trimap = imread(trimap_path);

alpha = calculate_alpha(rgb, trimap, 8, 3);

% Display the result
gt = imread("GT01.png");
figure(1);

subplot(2,2,1);
imshow(rgb);

subplot(2,2,2);
imshow(trimap);

subplot(2,2,3);
imshow(gt);

subplot(2,2,4);
imshow(alpha);