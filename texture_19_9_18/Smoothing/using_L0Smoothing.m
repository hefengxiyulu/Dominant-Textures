clear all
close all
addpath(genpath(pwd));
%% input the picture
[FileName, FilePath]=uigetfile('*.jpg;*.png;*.tif;*.img;*.bmp;*.gif;','ÇëÑ¡ÔñÍ¼ÏñÊý¾Ý');
str=[FilePath FileName];
Im=imread(str);
S  = L0Smoothing(Im); % Default Parameters (lambda = 2e-2, kappa = 2)
figure
imshow(Im); 
figure
imshow(S);
%% saving image
path_name='./Smoothing/';
file_name='shadow_matrix_LR_UD';
save([path_name,file_name],'final_matrix_LR_UD');
imwrite(final_matrix_LR_UD,'final_matrix_LR_UD.jpg');