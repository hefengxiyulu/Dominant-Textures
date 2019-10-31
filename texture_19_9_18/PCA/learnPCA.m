%%
%���´���Ϊ�˽�PCA�㷨����д
%%
close all
clear;
clc;
addpath(genpath(pwd));
%% input the picture
[FileName, FilePath]=uigetfile('*.jpg;*.png;*.tif;*.img;*.bmp;*.gif;','��ѡ��ͼ������');
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
% X:ԭʼ���ݣ��д������ָ�꣬�д���������
% coeff:��������ʾ�Ӵ�С������ֵ��Ӧ������������
% score:���յó������ɷֵĶ�Ӧֵ��ÿ�б�ʾһ�����ɷ֣�����1���ɷֵ���p���ɷ����У�ÿ�б�ʾԭ�ȵ���������1��n��
% latent:�ǴӴ�С�������ɷֶ�Ӧ������ֵ��
% tsquare:��Hotelling's T-squareͳ����������һ���ò�����
% explained:��ÿһ�����ɷֽ����˶��ٰٷֱȵķ����һ���������������ۼӵ��趨��ֵ85%����80%��
[coeff,score,latent,tsquared,explained]=pca(X);
%%
[p,princ,egenvalue]=princomp(X);
%%
[r ,c ,bands]=size(X);
pixels=r;
tempX=X;
% ���ͨ���ľ�ֵ
meanValue =  mean(X,1);
% ����ȥ���Ļ�
X = X - repmat(meanValue,r,1);
% ��Э�������
correlation = (X'*X)/(pixels-1);
%����������������ֵ
[vector ,value] = eig(correlation);
% ����ֵ�����������Ӵ�С����
vector = fliplr(vector);
value = fliplr(value);
value = flipud(value);
%% ��֤
PC = tempX*vector; 
%%
[p,princ,egenvalue]=princomp(X);