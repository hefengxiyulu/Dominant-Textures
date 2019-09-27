%% This part of the code is mainly used for structure texture extract 
% 首先求梯度，连接各个小块的边缘，并统计小块的面积，合并相似的块
% 
%%
close all
addpath(genpath(pwd));
%% input the picture
[FileName, FilePath]=uigetfile('*.jpg;*.png;*.tif;*.img;*.bmp;*.gif;','请选择图像数据');
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
stdr=std(gray_pca);                       %求各变量的标准差；
[n,m]=size(gray_pca);               %矩阵的行与列
sddata=gray_pca./stdr(ones(n,1),:);         %标准化变换
[p,princ,egenvalue]=princomp(sddata);  %调用主成分
p=p(:,1:3);                          %输出前3主成分系数；
sc=princ(:,1:3);                       %前3主成分量；
egenvalue;                              %相关系数矩阵的特征值，即各主成分所占比例；
per=100*egenvalue/sum(egenvalue);       %各个主成分所占百分比；
%[coef,score,latent,t2] = princomp(im2double(img_gray))
%%
temp_img_gray=img_gray;
temp_img_gray=im2double(temp_img_gray);
[out_row_gray,out_colum_gray,out_final_gray,out_eight_final]=Gradient_calculation(temp_img_gray);%Calculate the gradient out_final_gray:四邻域计算;out_eight_final:八邻域计算
temp_abs_gray_gradient=im2uint8(out_eight_final);
figure
imshow(temp_abs_gray_gradient);
title('gradient image');
%%
%二次梯度
[out_row_gray2,out_colum_gray2,out_final_gray2,out_eight_final2]=Gradient_calculation(out_eight_final);%Calculate the gradient out_final_gray:四邻域计算;out_eight_final:八邻域计算
temp_abs_gray_gradient2=im2uint8(out_eight_final2);

tbl=tabulate(temp_abs_gray_gradient(:));
set(0,'defaultfigurecolor','w')
plot(tbl(:,1)',tbl(:,2)','b');%蓝色
hold on
tbl2=tabulate(temp_abs_gray_gradient2(:));
plot(tbl2(:,1)',tbl2(:,2)','r');%红色
legend('一次梯度','二次梯度');
xlabel('梯度值');
ylabel('同梯度总数');

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
title('边界')
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
latent=100*latent/sum(latent)%将latent总和统一为100，便于观察贡献率
pareto(latent);%调用matla画图