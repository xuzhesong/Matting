clc;
clear;
close all;

rgb_path = 'test/GT08_image.png';
trimap_path = 'test/GT08_trimap.png';
rgb = imread(rgb_path);
trimap = imread(trimap_path);
%%
tic;
alpha = calculate_alpha(rgb_path, trimap_path, 8, 10);
toc;
alpha = imbinarize(alpha);
%%

F(:,:,1) = double(alpha) .* double(rgb(:,:,1));
F(:,:,2) = double(alpha) .* double(rgb(:,:,2));
F(:,:,3) = double(alpha) .* double(rgb(:,:,3));
B(:,:,1) = double(1 - alpha) .* double(rgb(:,:,1));
B(:,:,2) = double(1 - alpha) .* double(rgb(:,:,2));
B(:,:,3) = double(1 - alpha) .* double(rgb(:,:,3));
% Display the result
gt = imread("./test/GT08.png");
figure(1);

subplot(3,2,1);
imshow(rgb);

subplot(3,2,2);
imshow(trimap);

subplot(3,2,3);
imshow(gt);

subplot(3,2,4);
imshow(alpha);

subplot(3,2,5);
imshow(uint8(F));

subplot(3,2,6);
imshow(uint8(B));

mse = MSE(alpha, double(gt));
disp(mse);
