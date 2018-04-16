clc;
addpath(genpath(pwd));
%%
[FileName, FilePath]=uigetfile('*.jpg;*.png;*.tif;*.img;*.bmp;*.gif;','ÇëÑ¡ÔñÍ¼ÏñÊı¾İ');
str=[FilePath FileName];
img_rgb=imread(str);
%%
[m n z]=size(img_rgb);
if(z>1)
    img_gray=rgb2gray(img_rgb);
end
img_hsi=rgb2hsi(img_rgb);
data_I=img_hsi(:,:,3);
data_S=img_hsi(:,:,2);
data_H=img_hsi(:,:,1);
%%
Intensity_256=uint8(256.*data_I);
Inten=im2uint8(data_I);
Hue_256=uint8(256.*data_H);
Hu=im2uint8(data_H);
Intensity_D_value=img_gray-Inten;
Hue_D_value=img_gray-Hu;
sum_Intensity=sum(Intensity_D_value(:));
sum_Hue=sum(Hue_D_value(:));
%%
figure
subplot(2,3,1);
imshow(img_rgb);
title('RGBÔ­Í¼');
hold on
subplot(2,3,2);
imshow(img_gray);
title('grayÍ¼Ïñ');
hold on
subplot(2,3,3);
imshow(img_hsi);
title('HSIÍ¼Ïñ');
hold on
subplot(2,3,4);
imshow(data_I);
title('IntensityÍ¼Ïñ');
hold on
subplot(2,3,5);
imshow(data_H);
title('HueÍ¼Ïñ');
hold off
%%
figure
imshow(Intensity_256);
figure
imshow(Hue_256);