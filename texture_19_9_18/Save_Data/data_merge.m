%%
%数据处理，即将不同patch获得的数据进行融合，然后将其映射至源图像
%%
clear all
close all
addpath(genpath(pwd));
%% input the picture
[FileName, FilePath]=uigetfile('*.jpg;*.png;*.tif;*.img;*.bmp;*.gif;','请选择图像数据');
str=[FilePath FileName];
img_rgb=imread(str);
%% load matrix
shadow_matrix_LR_7=cell2mat(struct2cell(load('shadow_matrix_LR_7.mat','shadow_matrix')));
shadow_matrix_LR_10=cell2mat(struct2cell(load('shadow_matrix_LR_10.mat','shadow_matrix')));
shadow_matrix_LR_13=cell2mat(struct2cell(load('shadow_matrix_LR_13.mat','shadow_matrix')));
%% load matrix
shadow_matrix_UD_7=cell2mat(struct2cell(load('shadow_matrix_UD_7')));
shadow_matrix_UD_10=cell2mat(struct2cell(load('shadow_matrix_UD_10')));
shadow_matrix_UD_13=cell2mat(struct2cell(load('shadow_matrix_UD_13')));
%% add the matrixes
[row,col,c]=size(img_rgb);
merge_matrix_LR=shadow_matrix_LR_7(1:row,1:col)+shadow_matrix_LR_10(1:row,1:col)+shadow_matrix_LR_13(1:row,1:col);
merge_matrix_UD=shadow_matrix_UD_7(1:row,1:col)+shadow_matrix_UD_10(1:row,1:col)+shadow_matrix_UD_13(1:row,1:col);
%% show left-right
figure
imshow(img_rgb)
out=shadow(merge_matrix_LR,0);
title('Left-right');
%% show up-down
figure
imshow(img_rgb)
out=shadow(merge_matrix_UD,0);
title('Up-Down');