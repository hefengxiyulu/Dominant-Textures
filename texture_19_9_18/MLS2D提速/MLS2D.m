% two-DIMENSIONAL MLS APPROXIMATION
% by Jin Jia
%% ͼ��Ȳ�������
clc
clear all


I=imread('22result.jpg');
[row,col,chn]=size(I);
% I=I(1:col,:,:);
% ���ýڵ�����
step=10;%����
xII=1: step : row;
yII=1: step : col;
[xI,yI] = meshgrid(yII,xII);
nnodes = size(xI,1)*size(yI,2);
% ���������������
[x,y] = meshgrid(1: 1 : col,1: 1: row);

npoints = size(x,1)*size(y,2);
scale = 30;
% ȷ��ÿ���ڵ��֧�ְ뾶
dmI = scale *0.5* ones(1, nnodes);
tic
% ��������������x��MLS��״����
[PHI, DPHIx, DPHIy] = MLS2DShape(6, nnodes, xI,yI, npoints, x,y, dmI, 'GAUSS', 3.0 ); 
toc
 
% �������. y = peaks(x,y)
ZII  =I(xII,yII,:);    % �ڵ㺯��ֵ 
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
for j=1:1
    ZI=ZII(:,:,j);
    for i=1:nnodes
        Znodes(1,i)=ZI(i);
    end                        %����ά����ת��Ϊһά����
    zh = PHI *Znodes';  % �ƽ�����
    II(:,:,j)=reshape(zh,row,col);
end
ZI=double(ZI);
plot3( xI, yI, ZI,'k.','LineWidth',2);
hold on
surf(x,y,II(:,:,j));
toc
% imshow(II);
% III=imsubtract(I,II);
% sum(sum(sum(III)))/(row*col*3)
