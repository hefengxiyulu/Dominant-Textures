%% This part of the code is mainly used for structural image exploration 
% Running this part of the code requires modifying the parameters of the
% shadow.m
%%
addpath(genpath(pwd));
%% input the picture
[FileName, FilePath]=uigetfile('*.jpg;*.png;*.tif;*.img;*.bmp;*.gif;','ÇëÑ¡ÔñÍ¼ÏñÊý¾Ý');
str=[FilePath FileName];
img_rgb=imread(str);
%% Convert the RGB image to HSI image
img_gray=im2double(rgb2gray(img_rgb));
% img_gray=rgb2gray(img_rgb);
img_hsi=rgb2hsi(img_rgb);
data_I=img_hsi(:,:,3);
data_S=img_hsi(:,:,2);
data_H=img_hsi(:,:,1);
Hue_data=data_H;
Intensity_data=data_I;
%% calculate the gradient
% [out_row_H,out_colum_H,out_final_H]=Gradient_calculation(data_H);
% [out_row_I,out_colum_I,out_final_I]=Gradient_calculation(data_I);
% [out_row_S,out_colum_S,out_final_S]=Gradient_calculation(data_S);
[out_row_gray,out_colum_gray,out_final_gray]=Gradient_calculation(img_gray);
%%
figure(1)
%% gray image
subplot(2,2,1);
imshow(out_row_gray);
title('gradient row image');
hold on 
subplot(2,2,2);
imshow(out_colum_gray);
title('gradient column image');
hold on 
subplot(2,2,3);
% out_final_gray=im2uint8(out_final_gray);
imshow(out_final_gray);
title('gradient final image');
hold on
subplot(2,2,4);
imshow(im2uint8(img_gray));
title('Gray image');
%% Hue image
% subplot(2,2,1);
% imshow(out_row_H);
% title('gradient row image');
% hold on 
% subplot(2,2,2);
% imshow(out_colum_H);
% title('gradient column image');
% hold on 
% subplot(2,2,3);
% imshow(out_final_H);
% title('gradient final image');
% hold on
% subplot(2,2,4);
% imshow(data_H);
% title('Hue iamge');
% hold off
%% intensity image 
% subplot(2,2,1);
% imshow(out_row_I);
% title('gradient row image');
% hold on 
% subplot(2,2,2);
% imshow(out_colum_I);
% title('gradient column image');
% hold on 
% subplot(2,2,3);
% imshow(out_final_I);
% title('gradient final image');
% hold on
% subplot(2,2,4);
% imshow(data_I);
% title('Intensity iamge');
% hold off
%% saturation iamge 
% subplot(2,2,1);
% imshow(out_row_S);
% title('gradient row image');
% hold on 
% subplot(2,2,2);
% imshow(out_colum_S);
% title('gradient column image');
% hold on 
% subplot(2,2,3);
% imshow(out_final_S);
% title('gradient final image');
% hold on
% subplot(2,2,4);
% imshow(data_S);
% title('Saturation iamge');
% hold off
%% Histogram statistics gray image
abs_gray_gradient=im2uint8(abs(out_final_gray));
% abs_gray_gradient=abs(out_final_gray);
out_level=gradient_data_statistic(abs_gray_gradient);
figure
imshow(img_rgb);
hold on;
out=shadow(abs_gray_gradient,30);
title('Gray-ÎÆÀíÍ¼Ïñ');
hold off
%%
patch_rgb_gray=rgb2gray(img_rgb);
% out_patch=patch_statistic(abs_gray_gradient); % used for obtain the gradient image statistic information
% out_patch_gray=patch_statistic(patch_rgb_gray);% this code used for obtain the original image statistic information
%%
vary_abs_gray_gradient=abs_gray_gradient;
vary_abs_gray_gradient(find( vary_abs_gray_gradient<50 ))=0;
% vary_scale_gradient=im2double(vary_abs_gray_gradient)% has the  thresholding
vary_scale_gradient=im2double(abs_gray_gradient);% no thresholding
out_gray_gradient_32=patchs(vary_scale_gradient,32,'Gray_gradient');
out_gray_gradient_64=patchs(vary_scale_gradient,64,'Gray_gradient');
out_gray_gradient_128=patchs(vary_scale_gradient,128,'Gray_gradient');
out_gray_gradient_256=patchs(vary_scale_gradient,256,'Gray_gradient');
%% compute the curve range of the corresponding curve
Gray_gradient_range_32=curve_range(out_gray_gradient_32(1,:));
Gray_gradient_range_64=curve_range(out_gray_gradient_64(1,:));
Gray_gradient_range_128=curve_range(out_gray_gradient_128(1,:));
Gray_gradient_range_256=curve_range(out_gray_gradient_256(1,:));
%%
gray_unit8=im2uint8(img_gray);
out_point=range_point(out_gray_gradient_32(1,:));    %% obtain the coordinate of the inflection point
scaled_img=scale_image(vary_scale_gradient,2);
block=texture(img_gray,scaled_img,out_point);     %% find the mask of the dominant texture
%%
[W,H]=size(block);
for i=1:W
    for j=1:H
        if(block(i,j)==0)
           img_gray(2*i-1,2*j-1)=1;
           img_gray(2*i-1,2*j)=1;
           img_gray(2*i,2*j-1)=1;
           img_gray(2*i,2*j)=1;
        end
    end
end
%%
figure
imshow(img_rgb);
hold on;
out=shadow(img_gray,1);
title('Intensity-ÎÆÀíÍ¼Ïñ')
%%
figure
 for i=1:6
        hold on
        plot(out_gray_gradient_32(i,:));
 end
%     title('Gray-gradient-Ö±·½Í¼');
figure
imshow(vary_abs_gray_gradient);
%% Hue iamge
% abs_H_gradient=im2uint8(abs(out_final_H));
% out=gradient_data_statistic(abs_H_gradient);
%%
% figure (3)
% imshow(img_rgb);
% hold on;
% out=shadow(abs_H_gradient,30);
% title('Intensity-ÎÆÀíÍ¼Ïñ');
% hold off
%% Intensity image 
% abs_I_gradient=im2uint8(abs(out_final_I));
% out=gradient_data_statistic(abs_I_gradient);
% figure (3)
% imshow(img_rgb);
% hold on;
% out=shadow(abs_I_gradient,5);
% title('Intensity-ÎÆÀíÍ¼Ïñ');
% hold off
%% saturation image
% abs_S_gradient=im2uint8(abs(out_final_S));
% out=gradient_data_statistic(abs_S_gradient);
set(gcf,'color','w');
% hold off