% two-DIMENSIONAL MLS APPROXIMATION
% by Jin Jia
%% ͼ���������MLS
clc
clear all;
close all;

I=imread('22result.jpg');
[row,col,chn]=size(I);

num=200;%�����������
nnodes=num;
I1=reshape(I,row*col,3);
xy=randi([1,row*col],1,num);
%�ڵ�����
[xI,yI]=ind2sub([row col],xy);
%��Ӧ��ֵ
ZII=double(I1(xy,:));%����

% ���������������
[x,y] = meshgrid(1: 1 : col,1: 1: row);

npoints = size(x,1)*size(y,2);
scale = 30;
% ȷ��ÿ���ڵ��֧�ְ뾶
dmI = scale *0.5* ones(1, nnodes);
tic
% ��������������x��MLS��״����
[PHI, DPHIx, DPHIy] = MLS2DShape(3, nnodes, yI,xI, npoints, x,y, dmI, 'GAUSS', 3.0 ); 
toc
 
% �������. y = peaks(x,y)
% ZII  =I(xII,yII,:);    % �ڵ㺯��ֵ 
% z  =x.*exp(-x.^2- y.^2);% ȷ�еĽ������
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
%     end                        %����ά����ת��Ϊһά����
    zh = PHI *ZI;  % �ƽ�����
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
