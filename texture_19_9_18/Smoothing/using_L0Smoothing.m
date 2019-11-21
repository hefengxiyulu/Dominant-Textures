clear all
close all
addpath(genpath(pwd));
%% input the picture
[FileName, FilePath]=uigetfile('*.jpg;*.png;*.tif;*.img;*.bmp;*.gif;','ÇëÑ¡ÔñÍ¼ÏñÊý¾Ý');
str=[FilePath FileName];
Im=imread(str);
%%
lambda = 5e-3;
kappa = 2;
S = L0Smoothing(Im,lambda); % Default Parameters (lambda = 2e-2, kappa = 2)
figure
imshow(Im); 
figure
imshow(S);
%% saving image
path_name='./Smoothing/';
file_name=strcat('L0SmoothImg_',num2str(lambda),'.jpg');
imwrite(S,[path_name,file_name]);
%%
lambda = 5e-2;
S = L0Smoothing(Im,lambda); % Default Parameters (lambda = 2e-2, kappa = 2)
figure
imshow(S);
%% saving image
path_name='./Smoothing/';
file_name=strcat('L0SmoothImg_',num2str(lambda),'.jpg');
imwrite(S,[path_name,file_name]);
%%