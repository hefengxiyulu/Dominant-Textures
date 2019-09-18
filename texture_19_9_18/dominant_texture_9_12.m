%% This part of the code is mainly used for structure texture extract 
% 首先求梯度，连接各个小块的边缘，并统计小块的面积，合并相似的块
% 
%%
close all
addpath(genpath(pwd));
%% input the picture
[FileName, FilePath]=uigetfile('*.jpg;*.png;*.tif;*.img;*.bmp;*.gif;','请选择图像数据');
str=[FilePath FileName];
img_rgb=imread(str);
%% Convert the RGB image to HSI image
img_gray=im2double(rgb2gray(img_rgb));
img_gray=rgb2gray(img_rgb);
img_hsi=rgb2hsi(img_rgb);
data_I=img_hsi(:,:,3);
data_S=img_hsi(:,:,2);
data_H=img_hsi(:,:,1);
Hue_data=data_H;
Intensity_data=data_I;
Saturation_data=data_S;
%%
temp_img_gray=img_gray;
temp_img_gray=im2double(temp_img_gray);
[out_row_gray,out_colum_gray,out_final_gray,out_eight_final]=Gradient_calculation(temp_img_gray);%Calculate the gradient out_final_gray:四邻域计算;out_eight_final:八邻域计算
temp_abs_gray_gradient=im2uint8(out_final_gray);
figure
imshow(temp_abs_gray_gradient);
title('gradient image');
%%
figure
imshow(Intensity_data);
title('Intensity image');
figure
imshow(Hue_data);
title('Hue Image');
figure
imshow(Saturation_data);
title('Saturation image');
[row_x,col_y]=size(Intensity_data);