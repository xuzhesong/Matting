clc;
clear;
close all;

rgb_path = 'test/GT01_image.png';
trimap_path = 'test/GT01_trimap.png';
rgb = imread(rgb_path);
trimap = imread(trimap_path);
%%
tic;
alpha = calculate_alpha(rgb_path, trimap_path, 8, 30);
toc;
%%
% Display the result
gt = imread("./test/GT01.png");
figure(1);

subplot(2,2,1);
imshow(rgb);

subplot(2,2,2);
imshow(trimap);

subplot(2,2,3);
imshow(gt);

subplot(2,2,4);
imshow(alpha);

mse = MSE(alpha, double(gt));
disp(mse);
