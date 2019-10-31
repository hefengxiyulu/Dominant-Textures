% two-DIMENSIONAL MLS APPROXIMATION
% by Jin Jia
%% 图像随机采样MLS
clc
clear all;
close all;

I=imread('22result.jpg');
[row,col,chn]=size(I);

num=200;%随机采样个数
nnodes=num;
I1=reshape(I,row*col,3);
xy=randi([1,row*col],1,num);
%节点坐标
[xI,yI]=ind2sub([row col],xy);
%对应的值
ZII=double(I1(xy,:));%更换

% 设置评估点的坐标
[x,y] = meshgrid(1: 1 : col,1: 1: row);

npoints = size(x,1)*size(y,2);
scale = 30;
% 确定每个节点的支持半径
dmI = scale *0.5* ones(1, nnodes);
tic
% 评估所有评估点x的MLS形状函数
[PHI, DPHIx, DPHIy] = MLS2DShape(3, nnodes, yI,xI, npoints, x,y, dmI, 'GAUSS', 3.0 ); 
toc
 
% 曲线拟合. y = peaks(x,y)
% ZII  =I(xII,yII,:);    % 节点函数值 
% z  =x.*exp(-x.^2- y.^2);% 确切的解决方案
Zpoints=zeros(1,npoints);
xh=zeros(1,npoints);
yh=zeros(1,npoints);
II=I-I;
for i=1:npoints
% Zpoints(1,i)=z(i);
xh(1,i)=x(i);
yh(1,i)=y(i);
end
Znodes=zeros(1,nnodes);
for j=1:3
    ZI=ZII(:,j);
%     for i=1:nnodes
%         Znodes(1,i)=ZI(:);
%     end                        %将二维数据转换为一维数据
    zh = PHI *ZI;  % 逼近函数
    II(:,:,j)=reshape(zh,row,col);
end
toc
ZI=double(ZI);
% plot3( xI, yI, ZI,'k.','LineWidth',2);
hold on
surf(x,y,II(:,:,1));
toc
% imshow(II);
% III=imsubtract(I,II);
% sum(sum(sum(III)))/(row*col*3)
