%% This part of the code is mainly used for structure texture extract 
% �������ݶȣ����Ӹ���С��ı�Ե����ͳ��С���������ϲ����ƵĿ�
% 
%%
close all
addpath(genpath(pwd));
%% input the picture
[FileName, FilePath]=uigetfile('*.jpg;*.png;*.tif;*.img;*.bmp;*.gif;','��ѡ��ͼ������');
str=[FilePath FileName];
img_rgb=imread(str);
%% Convert the RGB image to HSI image
%img_gray=im2double(rgb2gray(img_rgb));
img_gray=rgb2gray(img_rgb);
img_hsi=rgb2hsi(img_rgb);
data_I=img_hsi(:,:,3);
data_S=img_hsi(:,:,2);
data_H=img_hsi(:,:,1);
Hue_data=data_H;
Intensity_data=data_I;
Saturation_data=data_S;
%% PCA 
gray_pca=double(img_gray);
stdr=std(gray_pca);                       %��������ı�׼�
[n,m]=size(gray_pca);               %�����������
sddata=gray_pca./stdr(ones(n,1),:);         %��׼���任
[p,princ,egenvalue]=princomp(sddata);  %�������ɷ�
p=p(:,1:3);                          %���ǰ3���ɷ�ϵ����
sc=princ(:,1:3);                       %ǰ3���ɷ�����
egenvalue;                              %���ϵ�����������ֵ���������ɷ���ռ������
per=100*egenvalue/sum(egenvalue);       %�������ɷ���ռ�ٷֱȣ�
%[coef,score,latent,t2] = princomp(im2double(img_gray))
%%
temp_img_gray=img_gray;
temp_img_gray=im2double(temp_img_gray);
[out_row_gray,out_colum_gray,out_final_gray,out_eight_final]=Gradient_calculation(temp_img_gray);%Calculate the gradient out_final_gray:���������;out_eight_final:���������
temp_abs_gray_gradient=im2uint8(out_eight_final);
figure
imshow(temp_abs_gray_gradient);
title('gradient image');
%%
%�����ݶ�
[out_row_gray2,out_colum_gray2,out_final_gray2,out_eight_final2]=Gradient_calculation(out_eight_final);%Calculate the gradient out_final_gray:���������;out_eight_final:���������
temp_abs_gray_gradient2=im2uint8(out_eight_final2);

tbl=tabulate(temp_abs_gray_gradient(:));
set(0,'defaultfigurecolor','w')
plot(tbl(:,1)',tbl(:,2)','b');%��ɫ
hold on
tbl2=tabulate(temp_abs_gray_gradient2(:));
plot(tbl2(:,1)',tbl2(:,2)','r');%��ɫ
legend('һ���ݶ�','�����ݶ�');
xlabel('�ݶ�ֵ');
ylabel('ͬ�ݶ�����');

%%
temp_abs_gray_gradient(find(temp_abs_gray_gradient<40))=0;%Modify the threshold to get a different gradient map
temp_vary_abs_gray_gradient=temp_abs_gray_gradient;
temp_vary_abs_gray_gradient(find(temp_vary_abs_gray_gradient>0))=255;
bw = im2bw(temp_vary_abs_gray_gradient);  % convert to binary img 
figure
imshow(bw );
title('binary img');
contour = bwperim(bw);                  
figure
imshow(contour);
title('contour img');
contour1 = edge(bw ,'canny');
figure
imshow(contour1);
title('�߽�')
%%
% figure
% imshow(Intensity_data);
% title('Intensity image');
% figure
% imshow(Hue_data);
% title('Hue Image');
% figure
% imshow(Saturation_data);
% title('Saturation image');
% [row_x,col_y]=size(Intensity_data);

%%
latent=100*latent/sum(latent)%��latent�ܺ�ͳһΪ100�����ڹ۲칱����
pareto(latent);%����matla��ͼ