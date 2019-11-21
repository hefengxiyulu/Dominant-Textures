%%
% 2019年11月19日 
%本代码主要涉及以下操作：
%使用matlab代码L0滤波图像，然后使用opencv提取图像轮廓，最后使用分块处理，提取轮廓图中结构的方向变化，并统计各个块内数据和的直方图。
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
temp_img_gray=double(img_gray);       %% convert to double type
temp_img_gray(temp_img_gray>100)=1;   %% 将非零数据转换为1，便于使用函数统计块内轮廓点的个数，即统计1的总个数
%% 图像旋转
% figure
% imshow(img_gray);
% figure
% rotate_img_gray= myimrotate(img_gray,-45);
% imshow(rotate_img_gray);
% figure
% imshow(myimrotate(rotate_img_gray,45));
% temp_img_gray=rotate_img_gray;
%%
fun = @(block_struct) sum(sum(block_struct.data));                    %Create block processing function.
patch_size_x=5;
patch_size_y=2;
tatistic_data=blockproc(temp_img_gray,[patch_size_x patch_size_y],fun);   % Select the appropriate batch size
%% Statistical the blocks-sum value distribution
stbl=tabulate(tatistic_data(:));
figure
plot(stbl(:,1),stbl(:,2)); %线性，颜色，标记
xlabel('块和的值');  %x轴坐标描述
ylabel('统计数');
title_name=strcat(num2str(patch_size_x),'x', num2str(patch_size_y),'块的统计图');
title(title_name);
set(0,'defaultfigurecolor','w');
set(gca,'XTick',0:1:17);
%%
[max_index_r max_index_c]=find(stbl(:,2)==max(stbl(:,2)));
max_value=stbl(max_index_r,1);
[sort_stbl_data,org_index]=sortrows(stbl,-2);       % 负数代表降序排列
%%  散点映射
[row col]=size(tatistic_data);
shadow_patch=zeros(row*patch_size_x,col*patch_size_y);
for i=1:row
    for j=1:col
        if tatistic_data(i,j)==sort_stbl_data(2,1);
            shadow_patch((i-1)*patch_size_x+1:(i)*patch_size_x,(j-1)*patch_size_y+1:(j)*patch_size_y)=1;
        end
    end
end
%%
figure
imshow(temp_img_gray)
out=shadow(shadow_patch,0);
title_name=strcat(num2str(patch_size_x),'x', num2str(patch_size_y),'块的映射图');
title(title_name);
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 以下代码为步长为1的统计代码
%% 步长为1的的统计
[row_0 col_0]=size(temp_img_gray);
tatistic_data_step_1=zeros(row_0-patch_size_x+1,col_0-patch_size_y+1);
for i=1:row_0-patch_size_x+1
    for j=1:col_0-patch_size_y+1
        temp_data=temp_img_gray(i:i+patch_size_x-1,j:j+patch_size_y-1);
        tatistic_data_step_1(i,j)=sum(sum(temp_data));
    end
end
%% Statistical the blocks-sum value distribution
stbl=tabulate(tatistic_data_step_1(:));
figure
plot(stbl(:,1),stbl(:,2)); %线性，颜色，标记
xlabel('块和的值');  %x轴坐标描述
ylabel('统计数');
title_name=strcat(num2str(patch_size_x),'x', num2str(patch_size_y),'块的统计图');
title(title_name);
set(0,'defaultfigurecolor','w');
set(gca,'XTick',0:1:17);
%% 排序
[sort_stbl_data,org_index]=sortrows(stbl,-2);       % 负数代表降序排列
%% 散点映射
[row_1 col_1]=size(tatistic_data_step_1);
shadow_patch=zeros(row_1+patch_size_x-1,col_1+patch_size_y-1);
for i=1:row_1
    for j=1:col_1
        if tatistic_data_step_1(i,j)==sort_stbl_data(2,1);
            shadow_patch(i:i+patch_size_x-1,j:j+patch_size_y-1)=1;
        end
    end
end
%%
figure
imshow(temp_img_gray)
out=shadow(shadow_patch,0);
title_name=strcat(num2str(patch_size_x),'x', num2str(patch_size_y),'块的映射图');
title(title_name);