
%%
clc;
clear all
close all
addpath(genpath(pwd));
%% input the picture
[FileName, FilePath]=uigetfile('*.jpg;*.png;*.tif;*.img;*.bmp;*.gif;','��ѡ��ͼ������');
str=[FilePath FileName];
% img_rgb=imread(str);
%%
%1.�����ɫͼ�� ��ת���ɻҶ�ͼ ��ʾ%
rgb=imread(str);
I=rgb2gray(rgb);
%2.���зָ�ͼ��%
hy = fspecial('sobel');
hx = hy';
Iy = imfilter(double(I),hy,'replicate');
Ix = imfilter(double(I),hx,'replicate');
gradmag = sqrt(Ix.^2+Iy.^2);

figure('units','normalized','position',[0.1 0.1 0.6 0.6]);
subplot(1,2,1);imshow(I,[]);title('�Ҷ�ͼ��');
subplot(1,2,2);imshow(gradmag,[]);title('�ݶȷ�ֵͼ��');

%3.���ǰ��Ŀ�����
%�ж��ַ������Ի��ǰ����� ����Ǳ�����ǰ�������ڲ������Ӱߵ�����
%��������԰ѽṹԪ��С��ͻ���˵� �ж�ϸ����Ӷ��𵽷�������
%��������԰ѽṹԪ��С��ȱ�ڻ������� ��Ӷεļ��������������
se = strel('disk',20);
Io = imopen(I,se);
Ie = imerode(I,se);
Iobr = imreconstruct(Ie,I);
Ioc = imclose(Io,se);
Ic = imclose(I,se);

%����imdilate imreconstruct ������ͼ���� ��imreconstruct���ͼ����
Iobrd = imdilate(Iobr,se);
Iobrcbr = imreconstruct(imcomplement(Iobrd),imcomplement(Iobr));
Iobrcbr = imcomplement(Iobrcbr);

%�Ƚ�Ioc��Iobrcbr,���Ƴ�С�۵�ͬʱ��Ӱ�����ȫ����״��Ӧ����
%�����ؽ��Ŀ��ղ���Ҫ�ȱ�׼�Ŀ����ؽ�������Ч
%����Iobrcbr�ľֲ�����ֵ���õ����õ�ǰ�����
fgm = imregionalmax(Iobrcbr);

%Ϊ�˰�������� ����ǰ����ǵ�ԭͼ��
It1 = rgb(:,:,1);It2 = rgb(:,:,2);It3 = rgb(:,:,3);
It1(fgm)=255;It2(fgm)=0;It3(fgm)=0;
I2 = cat(3,It1,It2,It3);

%ע�� ������������Ӱ����û�б���� ���ڽ���н�����õ�����ķָ�
%�����ǰߵ�ı�Ե Ȼ����������
%�ղ����͸�ʴ�������
se2 = strel(ones(5,5));
fgm2 = imclose(fgm,se2);
fgm3 = imerode(fgm2,se2);

%������̻�����һЩƫ��Ĺ������أ�Ӧ���Ƴ�����
%����bwareaopen�Ƴ������ض����ظ����İߵ�
fgm4 = bwareaopen(fgm3,20);
It1 = rgb(:,:,1);
It2 = rgb(:,:,2);
It3 = rgb(:,:,3);
It1(fgm4)=255;
It2(fgm4)=0;
It3(fgm4)=0;
I3 = cat(3,It1,It2,It3);

%4.���㱳�����
%��Iobrcbr�� ���������ڱ��� ��ֵ����
bw = im2bw(Iobrcbr,graythresh(Iobrcbr));
figure('units','normalized','position',[0.1 0.1 0.6 0.6]);
subplot(1,2,1);imshow(Iobrcbr,[]);title('�����ؽ��Ŀ��ղ���');
subplot(1,2,2);imshow(bw,[]);title('��ֵ�ָ�');

%���������ں�ɫ���� ���������� ����Ҫ�󱳾����̫�ӽ���Ҫ�ָ�Ķ����Ե��
%Ȼ��Ѱ�ҽ���ķ�ˮ�뼹��DL==0
D=bwdist(bw);
DL=watershed(D);
bgm = DL == 0;
 
%5.�����ˮ��ָ�
%imimposemin�����޸�ͼ�� ʹ�ض�Ҫ��λ�þֲ���С
gradmag2 = imimposemin(gradmag,bgm|fgm4);

%6.���ڷ�ˮ��ͼ��ķָ����
%����߽綨λ��L==0��λ�ã�
L=watershed(gradmag2);
It1 = rgb(:,:,1);
It2 = rgb(:,:,2);
It3 = rgb(:,:,3);
fgm5 = imdilate(L==0,ones(3,3)) | bgm | fgm4;
It1(fgm5)=255;
It2(fgm5)=0;   
It3(fgm5)=0;   
I4=cat(3,It1,It2,It3);

%��һ���ӻ����� ����Ǿ�����Ϊ��ɫͼ����ʾ
Lrgb = label2rgb(L,'jet','w','shuffle');

%ʹ��͸�������������α��ɫ��Ǿ�����ԭ����ͼ���Ͻ�����ʾ
figure('units','normalized','position',[0.1 0.1 0.6 0.6]);
subplot(1,2,1);imshow(rgb,[]);title('ԭͼ��');
subplot(1,2,2);imshow(rgb,[]);hold on;
himage = imshow(Lrgb);
set(himage,'AlphaData',0.3);
title('��Ǿ�����ӵ�ԭͼ��');