
%%
clc;
clear all
close all
addpath(genpath(pwd));
%% input the picture
[FileName, FilePath]=uigetfile('*.jpg;*.png;*.tif;*.img;*.bmp;*.gif;','请选择图像数据');
str=[FilePath FileName];
% img_rgb=imread(str);
%%
%1.读入彩色图像 并转换成灰度图 显示%
rgb=imread(str);
I=rgb2gray(rgb);
%2.进行分割图像%
hy = fspecial('sobel');
hx = hy';
Iy = imfilter(double(I),hy,'replicate');
Ix = imfilter(double(I),hx,'replicate');
gradmag = sqrt(Ix.^2+Iy.^2);

figure('units','normalized','position',[0.1 0.1 0.6 0.6]);
subplot(1,2,1);imshow(I,[]);title('灰度图像');
subplot(1,2,2);imshow(gradmag,[]);title('梯度幅值图像');

%3.标记前景目标对象
%有多种方法可以获得前景标记 但标记必须是前景对象内部的连接斑点像素
%开运算可以把结构元素小的突刺滤掉 切断细长搭接而起到分离作用
%闭运算可以把结构元素小的缺口或孔填充上 搭接段的间隔而起到连接作用
se = strel('disk',20);
Io = imopen(I,se);
Ie = imerode(I,se);
Iobr = imreconstruct(Ie,I);
Ioc = imclose(Io,se);
Ic = imclose(I,se);

%采用imdilate imreconstruct 对输入图像求补 对imreconstruct输出图像求补
Iobrd = imdilate(Iobr,se);
Iobrcbr = imreconstruct(imcomplement(Iobrd),imcomplement(Iobr));
Iobrcbr = imcomplement(Iobrcbr);

%比较Ioc和Iobrcbr,在移除小污点同时不影响对象全局形状的应用下
%基于重建的开闭操作要比标准的开闭重建更加有效
%计算Iobrcbr的局部极大值来得到更好地前景标记
fgm = imregionalmax(Iobrcbr);

%为了帮助理解结果 叠加前景标记到原图中
It1 = rgb(:,:,1);It2 = rgb(:,:,2);It3 = rgb(:,:,3);
It1(fgm)=255;It2(fgm)=0;It3(fgm)=0;
I2 = cat(3,It1,It2,It3);

%注意 大多闭塞出和阴影对象没有被标记 即在结果中将不会得到合理的分割
%清理标记斑点的边缘 然后收缩它们
%闭操作和腐蚀操作完成
se2 = strel(ones(5,5));
fgm2 = imclose(fgm,se2);
fgm3 = imerode(fgm2,se2);

%这个过程会留下一些偏离的孤立像素，应该移除它们
%采用bwareaopen移除少于特定像素个数的斑点
fgm4 = bwareaopen(fgm3,20);
It1 = rgb(:,:,1);
It2 = rgb(:,:,2);
It3 = rgb(:,:,3);
It1(fgm4)=255;
It2(fgm4)=0;
It3(fgm4)=0;
I3 = cat(3,It1,It2,It3);

%4.计算背景标记
%在Iobrcbr中 暗像素属于北京 阈值操作
bw = im2bw(Iobrcbr,graythresh(Iobrcbr));
figure('units','normalized','position',[0.1 0.1 0.6 0.6]);
subplot(1,2,1);imshow(Iobrcbr,[]);title('基于重建的开闭操作');
subplot(1,2,2);imshow(bw,[]);title('阈值分割');

%背景像素在黑色区域 理想情形下 不必要求背景标记太接近于要分割的对象边缘；
%然后寻找结果的分水岭脊线DL==0
D=bwdist(bw);
DL=watershed(D);
bgm = DL == 0;
 
%5.计算分水岭分割
%imimposemin用来修改图像 使特定要求位置局部最小
gradmag2 = imimposemin(gradmag,bgm|fgm4);

%6.基于分水岭图像的分割计算
%对象边界定位于L==0的位置；
L=watershed(gradmag2);
It1 = rgb(:,:,1);
It2 = rgb(:,:,2);
It3 = rgb(:,:,3);
fgm5 = imdilate(L==0,ones(3,3)) | bgm | fgm4;
It1(fgm5)=255;
It2(fgm5)=0;   
It3(fgm5)=0;   
I4=cat(3,It1,It2,It3);

%另一可视化技术 将标记矩阵作为彩色图象显示
Lrgb = label2rgb(L,'jet','w','shuffle');

%使用透明度来叠加这个伪彩色标记矩阵在原亮度图像上进行显示
figure('units','normalized','position',[0.1 0.1 0.6 0.6]);
subplot(1,2,1);imshow(rgb,[]);title('原图像');
subplot(1,2,2);imshow(rgb,[]);hold on;
himage = imshow(Lrgb);
set(himage,'AlphaData',0.3);
title('标记矩阵叠加到原图像');