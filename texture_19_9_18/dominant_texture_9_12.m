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
imageCanny=edge(img_gray,'canny');
% imshow(imageCanny);
% title('canny image');
img_hsi=rgb2hsi(img_rgb);
data_I=img_hsi(:,:,3);
data_S=img_hsi(:,:,2);
data_H=img_hsi(:,:,1);
Hue_data=data_H;
Intensity_data=data_I;
Saturation_data=data_S;
%% PCA 
gray_pca=double(img_gray);
stdr=std(gray_pca);                         %求各列变量的标准差；
[n,m]=size(gray_pca);                       %矩阵的行与列
sddata=gray_pca./stdr(ones(n,1),:);         %标准化变换
[p,princ,egenvalue]=princomp(sddata);       %调用主成分
p=p(:,1:3);                                 %输出前3主成分系数；
sc=princ(:,1:3);                            %前3主成分量；
egenvalue;                                  %相关系数矩阵的特征值，即各主成分所占比例；
per=100*egenvalue/sum(egenvalue);           %各个主成分所占百分比；
%[coef,score,latent,t2] = princomp(im2double(img_gray))
%mul = imread('images/0.bmp');
%extract_pca(img_rgb);%%调用PCA
%%
n_0=ceil(n/9);
m_0=ceil(m/9);
temp_gray_pca=zeros(n_0*9,m_0*9);
temp_gray_pca(1:n,1:m)=gray_pca;
pca_matrix0 = zeros(9);
pca_matrix1 = zeros(5);
eigenvalue_x=zeros(1,n_0*m_0);   %存储大矩阵的特征值
eigenvalue_y=zeros(1,n_0*m_0);   %存储小矩阵的特征值
index=1;
for i=1:n_0
    for j=1:m_0
        pca_matrix0=temp_gray_pca((1+(i-1)*9):i*9,(1+(j-1)*9):j*9);
        pca_matrix1=pca_matrix0(3:7,3:7);
        [coeff_0,score_0,latent_0,tsquared_0,explained_0]=pca(pca_matrix0);
        [coeff_1,score_1,latent_1,tsquared_1,explained_1]=pca(pca_matrix1);
        eigenvalue_x(index)=latent_0(1);
        eigenvalue_y(index)=latent_1(1);
        index=index+1;
    end
end
figure
scatter(eigenvalue_x,eigenvalue_y,'*b'); %线性，颜色，标记
xlabel('bigger patch特征值');  %x轴坐标描述
ylabel('smaller patch 特征值');  %x轴坐标描述
set(0,'defaultfigurecolor','w');
%%  
temp_gray_pca_fill=zeros(n+8,m+8);               %预先定义一个全0矩阵，边界扩大8        
temp_gray_pca_fill(5:n+4,5:m+4)=gray_pca;        %将原矩阵赋值给中间部分
storage_sta_value=zeros(n*m,16);                 %存储相关统计数据
sta_index=1;                                     %统计数据计数
for i=5:n+4
    for j=5:m+4
        pca_matrix_9=temp_gray_pca_fill((i-4):(i+4),(j-4):(j+4));   % 9*9
        pca_matrix_7=temp_gray_pca_fill((i-3):(i+3),(j-3):(j+3));   % 7*7
        pca_matrix_5=temp_gray_pca_fill((i-2):(i+2),(j-2):(j+2));   % 5*5
        pca_matrix_3=temp_gray_pca_fill((i-1):(i+1),(j-1):(j+1));   % 3*3
        % 求矩阵的均值                                 求矩阵的方差
        mean_value_9=mean(mean(pca_matrix_9)); 
        mean_value_7=mean(mean(pca_matrix_7));
        mean_value_5=mean(mean(pca_matrix_5));
        mean_value_3=mean(mean(pca_matrix_3));
        %求矩阵的均方差
        std_value_9=std2(pca_matrix_9);
        std_value_7=std2(pca_matrix_7);
        std_value_5=std2(pca_matrix_5);
        std_value_3=std2(pca_matrix_3);
        %统计直方图
        stbl_9=tabulate(pca_matrix_9(:));
        stbl_7=tabulate(pca_matrix_7(:));
        stbl_5=tabulate(pca_matrix_5(:));
        stbl_3=tabulate(pca_matrix_3(:));
        %计算直方图的均值
        stbl_mean_v_9=mean(stbl_9(:,2));
        stbl_mean_v_7=mean(stbl_7(:,2));
        stbl_mean_v_5=mean(stbl_5(:,2));
        stbl_mean_v_3=mean(stbl_3(:,2));
        %计算直方图的均方差
        stbl_std_v_9=std(stbl_9(:,2));
        stbl_std_v_7=std(stbl_7(:,2));
        stbl_std_v_5=std(stbl_5(:,2));
        stbl_std_v_3=std(stbl_9(:,2));
        storage_sta_value(sta_index,:)=[mean_value_9,mean_value_7,mean_value_5,mean_value_3,  std_value_9,std_value_7,std_value_5,std_value_3, ...
            stbl_mean_v_9,stbl_mean_v_7, stbl_mean_v_5,stbl_mean_v_3,   stbl_std_v_9,stbl_std_v_7,stbl_std_v_5,stbl_std_v_3];
        sta_index=sta_index+1;
    end
end

%%
k_x= find(eigenvalue_x<22500);
k_y = find(eigenvalue_y<6500);
result=ismember(k_y,k_x);
%% 填充阴影
shadow_gray_pca=ones(n_0*9,m_0*9);
for m=1:size(result,2)
    if result(m)==1
       i=floor(k_y(m)/m_0);
       j=mod(k_y(m),m_0);
       if j==0
           j=13;
           i=i-1;
       end
       shadow_gray_pca((i*9)+1:(i+1)*9,(j-1)*9+1:j*9)=0;
    end
end
figure
imshow(img_rgb);
out=shadow(shadow_gray_pca,1);
%%
temp_gray=img_gray;
temp_img_gray=double(img_gray(37:51,10:24));
temp_img_gray1=double(img_gray(39:49,12:22));
temp_img_gray2=double(img_gray(41:48,14:21));

temp_img_gray3=double(img_gray(27:51,10:24));
temp_img_gray4=double(img_gray(27:51,10:32));
temp_img_gray5=double(img_gray(27:41,10:32));

temp_img_gray6=double(img_gray(27:41,37:59));
temp_img_gray7=double(img_gray(27:51,37:59));
temp_img_gray8=double(img_gray(27:51,11:59));

temp_img_gray9=double(img_gray(27:60,11:78));

figure
imshow(img_gray);
rectangle('position',[10, 37, 14, 14],'edgecolor','g');
rectangle('position',[12, 39, 10, 10],'edgecolor','c');
rectangle('position',[14, 41, 7, 7],'edgecolor','r');

rectangle('position',[10, 27, 14, 24],'edgecolor','y');
rectangle('position',[10, 27, 22, 24],'edgecolor','m');
rectangle('position',[10, 27, 22, 14],'edgecolor','b');

rectangle('position',[37, 27, 22, 14],'edgecolor','k');
rectangle('position',[37, 27, 22, 24],'edgecolor','m');
rectangle('position',[11, 27, 48, 24],'edgecolor','g');

rectangle('position',[11, 27, 67, 33],'edgecolor','y');

[coeff,score,latent,tsquared,explained]=pca(temp_img_gray);
[coeff1,score1,latent1,tsquared1,explained1]=pca(temp_img_gray1);
[coeff2,score2,latent2,tsquared2,explained2]=pca(temp_img_gray2);
[coeff3,score3,latent3,tsquared3,explained3]=pca(temp_img_gray3);
[coeff4,score4,latent4,tsquared4,explained4]=pca(temp_img_gray4);
[coeff5,score5,latent5,tsquared5,explained5]=pca(temp_img_gray5);
[coeff6,score6,latent6,tsquared6,explained6]=pca(temp_img_gray6);
[coeff7,score7,latent7,tsquared7,explained7]=pca(temp_img_gray7);
[coeff8,score8,latent8,tsquared8,explained8]=pca(temp_img_gray8);
[coeff9,score9,latent9,tsquared9,explained9]=pca(temp_img_gray9);
%%
figure
set(0,'defaultfigurecolor','w')
eigenvalue=[latent(1),latent1(1),latent2(1),latent3(1),latent4(1),latent5(1),latent6(1),latent7(1),latent8(1),latent9(1)];
x=1:1:10;%x轴上的数据，第一个值代表数据开始，第二个值代表间隔，第三个值代表终止
plot(x,eigenvalue,'-*b'); %线性，颜色，标记
ylabel('特征值');  %x轴坐标描述
set(0,'defaultfigurecolor','w');
%%
temp_gray(41:48,14:21)=0;
figure
imshow(temp_gray);
temp_gray(39:49,12:22)=0;
figure
imshow(temp_gray);
img_gray(37:51,10:24)=0;
figure
imshow(img_gray);

img_gray(27:60,11:78)=0;
figure
imshow(img_gray);
%% 一次梯度
temp_img_gray=img_gray;
temp_img_gray=im2double(temp_img_gray);
[out_row_gray,out_colum_gray,out_final_gray,out_eight_final]=Gradient_calculation(temp_img_gray);%Calculate the gradient out_final_gray:四邻域计算;out_eight_final:八邻域计算
temp_abs_gray_gradient=im2uint8(out_final_gray);
figure
imshow(temp_abs_gray_gradient);
rectangle('position',[14, 40, 7, 7],'edgecolor','r');
rectangle('position',[12, 40, 7, 7],'edgecolor','g');
title('4-gradient image');
%% show
binary_gradient = temp_abs_gray_gradient;
binary_gradient(find(binary_gradient<40))=0;%Modify the threshold to get a different gradient map
binary_gradient(find(binary_gradient>0))=255;
figure
imshow(binary_gradient);
rectangle('position',[14, 40, 7, 7],'edgecolor','r');
rectangle('position',[12, 40, 7, 7],'edgecolor','g');
title('binary image');
%% 二次梯度
[out_row_gray2,out_colum_gray2,out_final_gray2,out_eight_final2]=Gradient_calculation(out_final_gray);%Calculate the gradient out_final_gray:四邻域计算;out_eight_final:八邻域计算
temp_abs_gray_gradient2=im2uint8(out_final_gray2);

tbl=tabulate(temp_abs_gray_gradient(:));%统计一个数组中各数字（元素）出现的频数、频率
set(0,'defaultfigurecolor','w')
figure
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
% latent=100*latent/sum(latent)%将latent总和统一为100，便于观察贡献率
% pareto(latent);%调用matla画图