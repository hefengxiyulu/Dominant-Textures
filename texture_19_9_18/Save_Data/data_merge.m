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
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% load matrix
shadow_matrix_LR_7=cell2mat(struct2cell(load('shadow_matrix_LR_7.mat','shadow_matrix')));
shadow_matrix_LR_10=cell2mat(struct2cell(load('shadow_matrix_LR_10.mat','shadow_matrix')));
shadow_matrix_LR_13=cell2mat(struct2cell(load('shadow_matrix_LR_13.mat','shadow_matrix')));

shadow_matrix_LR_8=cell2mat(struct2cell(load('shadow_matrix_LR_8.mat','shadow_matrix')));
shadow_matrix_LR_9=cell2mat(struct2cell(load('shadow_matrix_LR_9.mat','shadow_matrix')));
shadow_matrix_LR_11=cell2mat(struct2cell(load('shadow_matrix_LR_11.mat','shadow_matrix')));
shadow_matrix_LR_12=cell2mat(struct2cell(load('shadow_matrix_LR_12.mat','shadow_matrix')));
%% preprocessing load-matrix L-R
shadow_matrix_LR_7(find(shadow_matrix_LR_7>0))=1;
shadow_matrix_LR_10(find(shadow_matrix_LR_10>0))=1;
shadow_matrix_LR_13(find(shadow_matrix_LR_13>0))=1;

shadow_matrix_LR_8(find(shadow_matrix_LR_8>0))=1;
shadow_matrix_LR_9(find(shadow_matrix_LR_9>0))=1;
shadow_matrix_LR_11(find(shadow_matrix_LR_11>0))=1;
shadow_matrix_LR_12(find(shadow_matrix_LR_12>0))=1;
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% load matrix
shadow_matrix_UD_7=cell2mat(struct2cell(load('shadow_matrix_UD_7')));
shadow_matrix_UD_10=cell2mat(struct2cell(load('shadow_matrix_UD_10')));
shadow_matrix_UD_13=cell2mat(struct2cell(load('shadow_matrix_UD_13')));

shadow_matrix_UD_8=cell2mat(struct2cell(load('shadow_matrix_UD_8')));
shadow_matrix_UD_9=cell2mat(struct2cell(load('shadow_matrix_UD_9')));
shadow_matrix_UD_11=cell2mat(struct2cell(load('shadow_matrix_UD_11')));
shadow_matrix_UD_12=cell2mat(struct2cell(load('shadow_matrix_UD_12')));
%% preprocessing load-matrix U-D
shadow_matrix_UD_7(find(shadow_matrix_UD_7>0))=1;
shadow_matrix_UD_10(find(shadow_matrix_UD_10>0))=1;
shadow_matrix_UD_13(find(shadow_matrix_UD_13>0))=1;

shadow_matrix_UD_8(find(shadow_matrix_UD_8>0))=1;
shadow_matrix_UD_9(find(shadow_matrix_UD_9>0))=1;
shadow_matrix_UD_11(find(shadow_matrix_UD_11>0))=1;
shadow_matrix_UD_12(find(shadow_matrix_UD_12>0))=1;
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% add the matrixes
[row,col,c]=size(img_rgb);
merge_matrix_LR=shadow_matrix_LR_7(1:row,1:col)+shadow_matrix_LR_10(1:row,1:col)+shadow_matrix_LR_13(1:row,1:col)+ ...
    shadow_matrix_LR_8(1:row,1:col)+shadow_matrix_LR_9(1:row,1:col)+shadow_matrix_LR_11(1:row,1:col)+shadow_matrix_LR_12(1:row,1:col);
merge_matrix_UD=shadow_matrix_UD_7(1:row,1:col)+shadow_matrix_UD_10(1:row,1:col)+shadow_matrix_UD_13(1:row,1:col)+ ...
    shadow_matrix_UD_8(1:row,1:col)+shadow_matrix_UD_9(1:row,1:col)+shadow_matrix_UD_11(1:row,1:col)+shadow_matrix_UD_12(1:row,1:col);
%% 将相同区域被标记两次以上的像素点保留
merge_matrix_LR(find(merge_matrix_LR<4))=0;
merge_matrix_LR(find(merge_matrix_LR>=4))=1;

merge_matrix_UD(find(merge_matrix_UD<4))=0;
merge_matrix_UD(find(merge_matrix_UD>=4))=1;
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
%%
final_matrix_LR_UD=merge_matrix_LR+merge_matrix_UD;
final_matrix_LR_UD(find(final_matrix_LR_UD<2))=0;
final_matrix_LR_UD(find(final_matrix_LR_UD==2))=1;
figure
imshow(img_rgb)
out=shadow(final_matrix_LR_UD,0);
title('final merge')
%% save data
path_name='./Watershed/';
file_name='shadow_matrix_LR_UD';
save([path_name,file_name],'final_matrix_LR_UD');
imwrite(final_matrix_LR_UD,'final_matrix_LR_UD.jpg');