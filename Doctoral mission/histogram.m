I=imread('fish.bmp');
I= rgb2gray(I);
figure;
imshow(I);
title('1yuantu');
figure;
imhist(I);
title('2zhifangtu');
[m,n]=size(I);%计算图像大小
[counts,x]=imhist(I,30);%计算有29个小区间的灰度直方图（把灰度值256个数平均分为29个区间） 
                        %counts为对应直方图数值，x为位置
counts=counts/m/n;%计算归一化灰度直方图各区间的值
figure;
stem(x,counts);%绘制归一化直方图
title('3guiyihuazhifangtu');