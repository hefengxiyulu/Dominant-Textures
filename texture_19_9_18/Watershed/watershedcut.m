
clear all
close all
addpath(genpath(pwd));
%% input the picture
[FileName, FilePath]=uigetfile('*.jpg;*.png;*.tif;*.img;*.bmp;*.gif;','ÇëÑ¡ÔñÍ¼ÏñÊý¾Ý');
str=[FilePath FileName];
f=imread(str);
f=rgb2gray(f);
% f=imread('d:\test2.jpg');
subplot(2,2,1);
imshow(f);
f=double(f);
hv=fspecial('prewitt');
hh=hv.';
gv=abs(imfilter(f,hv,'replicate'));
gh=abs(imfilter(f,hh,'replicate'));
g=sqrt(gv.^2+gh.^2);
subplot(2,2,2);
L=watershed(g);
wr=L==0;
imshow(wr);
f(wr)=255;
subplot(2,2,3);
imshow(uint8(f));
rm=imregionalmin(g);
subplot(2,2,4);
imshow(rm);


