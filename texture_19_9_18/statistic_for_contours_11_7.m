%%
% 创建于2019年11月7日
% statistic_for_contours_10_30.m的替换版本，由于原版本中含有过多试验证明失败的代码，因此该版本为原代码的改进版，主要应用DBScan聚类算法进行散点的聚类。
%使用opencv寻找到轮廓，并保存为图片。然后在matlab中导入。最后进行分块处理，统计每个块中轮廓像素的个数。
%%
close all
addpath(genpath(pwd));
%% input the picture
[FileName, FilePath]=uigetfile('*.jpg;*.png;*.tif;*.img;*.bmp;*.gif;','请选择图像数据');
str=[FilePath FileName];
img_rgb=imread(str);
img_original=imread('\images\0.bmp'); %%input original image
%% convert to gray image
img_gray=rgb2gray(img_rgb);
img_gray(img_gray<100)=0;
%%
figure
imshow(img_gray);
%%
temp_img_gray=double(img_gray);       %% convert to double type
temp_img_gray(temp_img_gray>100)=1;   %% 将非零数据转换为1，便于使用函数统计块内轮廓点的个数，即统计1的总个数
%%
fun = @(block_struct) sum(sum(block_struct.data));                    %Create block processing function.
patch_size=13;
tatistic_data=blockproc(temp_img_gray,[patch_size patch_size],fun);   % Select the appropriate batch size
%% left to right
[row,col]=size(tatistic_data);
left_right=zeros(2,(col-1)*row);
sta_index=1;
for j=1:row
    for i=1:col-1
        left_right(1,sta_index)=tatistic_data(j,i);
        left_right(2,sta_index)=tatistic_data(j,i+1);
        sta_index=sta_index+1;
    end
end
%% show
figure
scatter(left_right(1,:),left_right(2,:),'*b'); %线性，颜色，标记
xlabel('left data');  %x轴坐标描述
ylabel('right data');
set(0,'defaultfigurecolor','w');
%% 统计每个散点周围出现散点的密度
[big_num]=max(left_right,[],2);
sta_frequency=zeros(big_num(1)+1,big_num(2)+1);       %%加1是为了存储0，即所有值均加1
for len=1:length(left_right)
    sta_frequency(left_right(1,len)+1,left_right(2,len)+1)=sta_frequency(left_right(1,len)+1,left_right(2,len)+1)+1;
end
%% 三维柱状图显示
figure
bar3(sta_frequency)
title('Frequency chart')
%% DBSCAN
out_Idx=my_DBScan(left_right(:,:)',1,2);  %%KNN k distance graph, to determine the epsilon
%%
[row,col]=size(tatistic_data);
out=texture_map(img_rgb,row,col,patch_size,out_Idx,0);