%%
% 2019年11月5日 
%使用opencv寻找到轮廓，并保存为图片。然后在matlab中导入。最后进行分块处理，统计每个块中轮廓像素的个数。
%10.30号统计的为left-right，本次处理up-down
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
% figure
% imshow(img_gray);
%%
temp_img_gray=double(img_gray);       %% convert to double type
temp_img_gray(temp_img_gray>100)=1;   %% 将非零数据转换为1，便于使用函数统计块内轮廓点的个数，即统计1的总个数
%%
fun = @(block_struct) sum(sum(block_struct.data));                    %Create block processing function.
patch_size=12;
tatistic_data=blockproc(temp_img_gray,[patch_size patch_size],fun);   % Select the appropriate batch size
%% up to down
[row,col]=size(tatistic_data);
up_down=zeros(2,col*(row-1));
sta_index=1;
for j=1:row-1
    for i=1:col
        up_down(1,sta_index)=tatistic_data(j,i);
        up_down(2,sta_index)=tatistic_data(j+1,i);
        sta_index=sta_index+1;
    end
end
%%  show
figure
scatter(up_down(1,:),up_down(2,:),'*g'); %线性，颜色，标记
xlabel('up data');  %x轴坐标描述
ylabel('down data');
set(0,'defaultfigurecolor','w');
%% 利用k-means聚类
[output]=k_means(up_down',4);
figure
for i=1:length(output)
    if output(i)==1
        hold on
        scatter(up_down(1,i),up_down(2,i),'*r'); %线性，颜色，标记
    elseif output(i)==2
        hold on
        scatter(up_down(1,i),up_down(2,i),'*g'); %线性，颜色，标记
    elseif output(i)==3
        hold on
        scatter(up_down(1,i),up_down(2,i),'*b'); %线性，颜色，标记
    else output(i)==4
        hold on
        scatter(up_down(1,i),up_down(2,i),'*c'); %线性，颜色，标记
    end
end
xlabel('up data');  %x轴坐标描述
ylabel('down data');
title('K-means');
hold off
%%  散点映射
shadow_gray_up_down=zeros(row*patch_size,col*patch_size);
for i=1:length(output)
    ii=floor(i/(col));
    jj=mod(i,(col));
    if jj==0
        jj=col;
        ii=ii-1;
    end
    shadow_gray_up_down((ii*patch_size)+1:(ii+2)*patch_size,(jj-1)*patch_size+1:jj*patch_size)=output(i);
end
%%
figure
imshow(img_rgb);
out=shadow_SB(shadow_gray_up_down);
title('up-down');
%% 统计每个散点周围出现散点的密度
[big_num]=max(up_down,[],2);
sta_frequency=zeros(big_num(1)+1,big_num(2)+1);       %%加1是为了存储0，即所有值均加1
for len=1:length(up_down)
    sta_frequency(up_down(1,len)+1,up_down(2,len)+1)=sta_frequency(up_down(1,len)+1,up_down(2,len)+1)+1;
end
%% 三维柱状图显示
figure
bar3(sta_frequency)
title('Frequency chart')
%% DBSCAN
out_Idx=my_DBScan(up_down(:,:)',1,2);  %%KNN k distance graph, to determine the epsilon
%%
[row,col]=size(tatistic_data);
out=texture_map(img_rgb,row,col,patch_size,out_Idx,1);
%%