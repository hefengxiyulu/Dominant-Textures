%%
%以下代码为了解PCA算法所编写
%%
close all
clear;
clc;
addpath(genpath(pwd));
%% input the picture
[FileName, FilePath]=uigetfile('*.jpg;*.png;*.tif;*.img;*.bmp;*.gif;','请选择图像数据');
str=[FilePath FileName];
img_rgb=imread(str);
%%
img_gray=rgb2gray(img_rgb);
temp_img_gray=double(img_gray(14:20,40:46));
[coeff,score,latent,tsquared,explained]=pca(temp_img_gray);
%%
%X=rand(10,4)*10;
X=temp_img_gray
%%
% X:原始数据，列代表变量指标，行代表样本。
% coeff:列向量表示从大到小的特征值对应的特征向量。
% score:最终得出的主成分的对应值，每列表示一个主成分，按第1主成分到第p主成分排列，每行表示原先的样本，从1到n。
% latent:是从大到小各个主成分对应的特征值。
% tsquare:是Hotelling's T-square统计量，我们一般用不到。
% explained:是每一个主成分解释了多少百分比的方差，是一个列向量（按此累加到设定阈值85%或者80%）
[coeff,score,latent,tsquared,explained]=pca(X);
%%
[p,princ,egenvalue]=princomp(X);
%%
[r ,c ,bands]=size(X);
pixels=r;
tempX=X;
% 求各通道的均值
meanValue =  mean(X,1);
% 数据去中心化
X = X - repmat(meanValue,r,1);
% 求协方差矩阵
correlation = (X'*X)/(pixels-1);
%求特征向量与特征值
[vector ,value] = eig(correlation);
% 特征值和特征向量从大到小排序
vector = fliplr(vector);
value = fliplr(value);
value = flipud(value);
%% 验证
PC = tempX*vector; 
%%
[p,princ,egenvalue]=princomp(X);