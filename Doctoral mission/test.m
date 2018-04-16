%% This code for the article Extracting Dominant Textures in Real Time With
%  Multi-Scale Hue-Saturation-Intensity Histograms 2017-8-10
%%
addpath(genpath(pwd));
%% input the picture
[FileName, FilePath]=uigetfile('*.jpg;*.png;*.tif;*.img;*.bmp;*.gif;','ÇëÑ¡ÔñÍ¼ÏñÊý¾Ý');
str=[FilePath FileName];
img_rgb=imread(str);
%% canny edge detect
[m n z]=size(img_rgb);
if(z>1)
    img_gray=rgb2gray(img_rgb);
end
BW1 = edge(img_gray,'canny');  % µ÷ÓÃcannyº¯Êý
% figure
% imshow(BW1);
% title('canny±ßÔµ¼ì²âÍ¼Ïñ');
statistic_data=blkproc(BW1,[2 2], 'sum2');
%% Convert the RGB image to HSI image
img_gray=rgb2gray(img_rgb);
img_hsi=rgb2hsi(img_rgb);
data_I=img_hsi(:,:,3);
data_S=img_hsi(:,:,2);
data_H=img_hsi(:,:,1);
Hue_data=data_H;
Intensity_data=data_I;
%% Calculation the D_value between the gray image and the HSI image
Inten=im2uint8(data_I);
Hu=im2uint8(data_H);
Intensity_D_value=img_gray-Inten;
Hue_D_value=img_gray-Hu;
sum_Intensity=sum(Intensity_D_value(:));
sum_Hue=sum(Hue_D_value(:));
%% Calculate the average value
mean_I=mean(mean(data_I));
mean_H=mean(mean(data_H));
mean_S=mean(mean(data_S));
mean_gray=mean(mean(img_gray));
%  Calculate the median value
median_I=median(median(data_I));
median_H=median(median(data_H));
median_S=median(median(data_S));
median_gray=median(median(img_gray));
% calculate the standard deviation value
std_I=std2(data_I);
std_H=std2(data_H);
std_S=std2(data_S);
std_gray=std2(img_gray);
%% construct multi-scale histgrams
% 32 level
out_Intensity_32=patchs(Intensity_data,32,'Intensity');
out_Hue_32=patchs(Hue_data,32,'Hue');
% 64 level
out_Intensity_64=patchs(Intensity_data,64,'Intensity');
out_Hue_64=patchs(Hue_data,64,'Hue');
% 128 level
out_Intensity_128=patchs(Intensity_data,128,'Intensity');
out_Hue_128=patchs(Hue_data,128,'Hue');
% 256 level
out_Intensity_256=patchs(Intensity_data,256,'Intensity');
out_Hue_256=patchs(Hue_data,256,'Hue');
%% Gets a histogram range greater than 0.05
Intensity_range_32=curve_range(out_Intensity_32(1,:));
Intensity_range_64=curve_range(out_Intensity_64(1,:));
Intensity_range_128=curve_range(out_Intensity_128(1,:));
Intensity_range_256=curve_range(out_Intensity_256(1,:));
%%%%%%%%
Hue_range_32=curve_range(out_Hue_32(1,:));
Hue_range_64=curve_range(out_Hue_64(1,:));
Hue_range_128=curve_range(out_Hue_128(1,:));
Hue_range_256=curve_range(out_Hue_256(1,:));
%% compute the values of the chi-square distance and the similarity
weight_I=(Intensity_range_32(2)-Intensity_range_32(1));
weight_H=(Hue_range_32(2)-Hue_range_32(1));

similarity_Intensity_32=(1/weight_I)*similarity(out_Intensity_32);
similarity_Hue_32=(1/weight_H)*similarity(out_Hue_32);

% similarity_Intensity_32=(1/exp(weight_I))*similarity(out_Intensity_32);
% similarity_Hue_32=(1/exp(weight_H))*similarity(out_Hue_32);
%%  Compare the value of  similarity_Intensity_32 and similarity_Hue_32
if (similarity_Intensity_32<=similarity_Hue_32)
% if(sum_Intensity<=sum_Hue)
    out_point=range_point(out_Intensity_32(1,:));    %% obtain the coordinate of the inflection point
    scaled_img=scale_image(Intensity_data,2);
    block=texture(data_I,scaled_img,out_point);     %% find the mask of the dominant texture
%%
   sum_ivalue=sum(out_Intensity_32(1,:));
   l_pi=out_point(2,1);
   r_pi=out_point(2,2);
   temp_ivalue=out_Intensity_32(1,:);
   partial_isum=sum(temp_ivalue(l_pi:r_pi));
   ratio_ivalue=partial_isum/sum_ivalue; 
else
    out_point=range_point(out_Hue_32(1,:));          %% obtain the coordinate of the inflection point
    scaled_img=scale_image(Hue_data,2);
    block=texture(data_H,scaled_img,out_point);      %% find the mask of the dominant texture
%%
   sum_hvalue=sum(out_Hue_32(1,:));
   l_ph=out_point(2,1);
   r_ph=out_point(2,2);
   temp_hvalue=out_Hue_32(1,:);
   partial_hsum=sum(temp_hvalue(l_ph:r_ph));
   ratio_hvalue=partial_hsum/sum_hvalue; 
end
%%
[W,H]=size(block);
for i=1:W
    for j=1:H
        if(block(i,j)==0)
            if(similarity_Intensity_32<=similarity_Hue_32)
%            if(sum_Intensity<=sum_Hue)
           data_I(2*i-1,2*j-1)=1;
           data_I(2*i-1,2*j)=1;
           data_I(2*i,2*j-1)=1;
           data_I(2*i,2*j)=1;
            else
           data_H(2*i-1,2*j-1)=1;
           data_H(2*i-1,2*j)=1;
           data_H(2*i,2*j-1)=1;
           data_H(2*i,2*j)=1;
            end
        end
    end
end
%% show subimage
figure
subplot(2,2,1);
imshow(img_rgb);
title('Ô­Ê¼Í¼Ïñ');
% ///////////////////////////////////////////
subplot(2,2,2);
if(similarity_Intensity_32<=similarity_Hue_32)
%     if(sum_Intensity<=sum_Hue)
    imshow(Intensity_data);
    title('Intensity-Í¼Ïñ');
else
   imshow(Hue_data);
    title('Hue-Í¼Ïñ');
end
%//////////////////////////////////////////////
subplot(2,2,3);
if(similarity_Intensity_32<=similarity_Hue_32)
% if(sum_Intensity<=sum_Hue)
    for i=1:6
        hold on
        plot(out_Intensity_32(i,:));
    end
    title('Intensity-Ö±·½Í¼');
else
    for i=1:6
        hold on
        plot(out_Hue_32(i,:));
    end
    title('Hue-Ö±·½Í¼');
end
%///////////////////////////////////////////////
subplot(2,2,4);
imshow(img_rgb);
hold on;
% imshow(data_I);
if(similarity_Intensity_32<=similarity_Hue_32)
% if(sum_Intensity<=sum_Hue)
    out=shadow(data_I,1);
    title('Intensity-ÎÆÀíÍ¼Ïñ');
else
    out=shadow(data_H,1);
    title('Hue-ÎÆÀíÍ¼Ïñ');
end
set(gcf,'color','w');
%%
