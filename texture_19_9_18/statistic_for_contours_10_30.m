%%
% 2019年10月30日 
%使用opencv寻找到轮廓，并保存为图片。然后在matlab中导入。最后进行分块处理，统计每个块中轮廓像素的个数。
%%
close all
addpath(genpath(pwd));
%% input the picture
[FileName, FilePath]=uigetfile('*.jpg;*.png;*.tif;*.img;*.bmp;*.gif;','请选择图像数据');
str=[FilePath FileName];
img_rgb=imread(str);
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
patch_size=10;
tatistic_data=blockproc(temp_img_gray,[patch_size patch_size],fun);   % Select the appropriate batch size
%% 
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
%%
figure
scatter(left_right(1,:),left_right(2,:),'*b'); %线性，颜色，标记
%plot(left_right(1,:),left_right(2,:)); %线性，颜色，标记
% xlabel('梯度值');  %x轴坐标描述
% ylabel('统计数');
set(0,'defaultfigurecolor','w');
%%
up_down=zeros(2,col*(row-1));
sta_index=1;
for j=1:row-1
    for i=1:col
        up_down(1,sta_index)=tatistic_data(j,i);
        up_down(2,sta_index)=tatistic_data(j+1,i);
        sta_index=sta_index+1;
    end
end
%%
figure
scatter(up_down(1,:),up_down(2,:),'*g'); %线性，颜色，标记
%plot(left_right(1,:),left_right(2,:)); %线性，颜色，标记
% xlabel('梯度值');  %x轴坐标描述
% ylabel('统计数');
set(0,'defaultfigurecolor','w');
