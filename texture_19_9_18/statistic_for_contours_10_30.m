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
patch_size=10;
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
%%
% [row,column]=find(sta_frequency==max(max(sta_frequency)));
% sta_frequency_1D=reshape(sta_frequency,1,[]);                  %%转换为1维数据
% [sort_sta_frequency_1D ind]= sort(sta_frequency_1D,'descend');
% [CCC, ia, ic] = unique(sort_sta_frequency_1D,'stable');        %%删除重复数据
%% 数据上下左右边缘均延伸3个0
[r_0,c_0]=size(sta_frequency);
sta_frequency_pad_0=zeros(r_0+6,c_0+6);
sta_frequency_pad_0(4:r_0+3,4:c_0+3)=sta_frequency;
%% 以每个非零元素为中心，分别统计其领域块的和，半径分别为1,2,3.
patch_sum_R_1=zeros(r_0+6,c_0+6);        %存储以当前像素为中心，邻域半径为1的块的和
patch_sum_R_2=zeros(r_0+6,c_0+6);        %~~~~邻域半径为2
patch_sum_R_3=zeros(r_0+6,c_0+6);        %~~~~邻域半径为3
for r_1=4:r_0+3
    for c_1=4:c_0+3
        if sta_frequency_pad_0(r_1,c_1)>0
            patch_sum_R_1(r_1,c_1)=sum(sum(sta_frequency_pad_0(r_1-1:r_1+1,c_1-1:c_1+1)));
            patch_sum_R_2(r_1,c_1)=sum(sum(sta_frequency_pad_0(r_1-2:r_1+2,c_1-2:c_1+2)));
            patch_sum_R_3(r_1,c_1)=sum(sum(sta_frequency_pad_0(r_1-3:r_1+3,c_1-3:c_1+3)));
        end
    end
end
%% show 3D img
figure
bar3(patch_sum_R_1);
title('Frequency chart R=1')
figure
bar3(patch_sum_R_2);
title('Frequency chart R=2')
figure
bar3(patch_sum_R_3);
title('Frequency chart R=3')
%%   最大值12
figure
for i=4:r_0+3
    for j=4:c_0+3
        if patch_sum_R_1(i,j)<5&patch_sum_R_1(i,j)>0
            hold on
            scatter(i-4,j-4,'*r'); %线性，颜色，标记    减4是为了将其移到原坐标系，前面处理边缘填充了0
        elseif patch_sum_R_1(i,j)>=5&patch_sum_R_1(i,j)<10
            hold on
            scatter(i-4,j-4,'*g'); %线性，颜色，标记    减4是为了将其移到原坐标系，前面处理边缘填充了0
        elseif patch_sum_R_1(i,j)>=10
            hold on
            scatter(i-4,j-4,'*b'); %线性，颜色，标记    减4是为了将其移到原坐标系，前面处理边缘填充了0
        end
    end
end
title('Radius=1');
xlabel('left data');  %x轴坐标描述
ylabel('right data');
hold off
%% 
figure
for i=4:r_0+3
    for j=4:c_0+3
        if patch_sum_R_2(i,j)<10&patch_sum_R_2(i,j)>0
            hold on
            scatter(i-4,j-4,'*r'); %线性，颜色，标记    减4是为了将其移到原坐标系，前面处理边缘填充了0
        elseif patch_sum_R_2(i,j)>=10&patch_sum_R_2(i,j)<20
            hold on
            scatter(i-4,j-4,'*g'); %线性，颜色，标记    减4是为了将其移到原坐标系，前面处理边缘填充了0
        elseif patch_sum_R_2(i,j)>=20
            hold on
            scatter(i-4,j-4,'*b'); %线性，颜色，标记    减4是为了将其移到原坐标系，前面处理边缘填充了0
        end
    end
end
title('Radius=2');
xlabel('left data');  %x轴坐标描述
ylabel('right data');
hold off
%% 显示散点图
figure
for i=4:r_0+3
    for j=4:c_0+3
        if patch_sum_R_3(i,j)<15&patch_sum_R_3(i,j)>0
            hold on
            scatter(i-4,j-4,'*r'); %线性，颜色，标记    减4是为了将其移到原坐标系，前面处理边缘填充了0
        elseif patch_sum_R_3(i,j)>=15&patch_sum_R_3(i,j)<30
            hold on
            scatter(i-4,j-4,'*g'); %线性，颜色，标记    减4是为了将其移到原坐标系，前面处理边缘填充了0
        elseif patch_sum_R_3(i,j)>=30
            hold on
            scatter(i-4,j-4,'*b'); %线性，颜色，标记    减4是为了将其移到原坐标系，前面处理边缘填充了0
        end
    end
end
title('Radius=3');
xlabel('left data');  %x轴坐标描述
ylabel('right data');
hold off
%%
%% 填充阴影 R=1
[row,col]=size(tatistic_data);
shadow_gray=zeros(row*patch_size,col*patch_size);
for i=4:r_0+3
    for j=4:c_0+3
         if patch_sum_R_1(i,j)<5&patch_sum_R_1(i,j)>0  %patch_sum_R_2(i,j)<10&patch_sum_R_2(i,j)>0
            k_x_1= find(left_right(1,:)==(i-4));
            k_y_1 = find(left_right(2,:)==(j-4));
            result_1=ismember(k_y_1,k_x_1);
            for m=1:size(result_1,2)
                if result_1(m)==1
                    ii=floor(k_y_1(m)/(col-1));
                    jj=mod(k_y_1(m),(col-1));
                    if jj==0
                        jj=col-1;
                        ii=ii-1;
                    end
                    shadow_gray((ii*patch_size)+1:(ii+1)*patch_size,(jj-1)*patch_size+1:(jj+1)*patch_size)=1;
                end
            end
            
         elseif patch_sum_R_1(i,j)>=5&patch_sum_R_1(i,j)<10
            k_x_1= find(left_right(1,:)==(i-4));
            k_y_1 = find(left_right(2,:)==(j-4));
            result_1=ismember(k_y_1,k_x_1);
            for m=1:size(result_1,2)
                if result_1(m)==1
                    ii=floor(k_y_1(m)/(col-1));
                    jj=mod(k_y_1(m),(col-1));
                    if jj==0
                        jj=col-1;
                        ii=ii-1;
                    end
                    shadow_gray((ii*patch_size)+1:(ii+1)*patch_size,(jj-1)*patch_size+1:(jj+1)*patch_size)=2;
                end
            end
            
         elseif patch_sum_R_1(i,j)>=10
            k_x_1= find(left_right(1,:)==(i-4));
            k_y_1 = find(left_right(2,:)==(j-4));
            result_1=ismember(k_y_1,k_x_1);
            for m=1:size(result_1,2)
                if result_1(m)==1
                    ii=floor(k_y_1(m)/(col-1));
                    jj=mod(k_y_1(m),(col-1));
                    if jj==0
                        jj=col-1;
                        ii=ii-1;
                    end
                    shadow_gray((ii*patch_size)+1:(ii+1)*patch_size,(jj-1)*patch_size+1:(jj+1)*patch_size)=3;
                end
            end
            
         end
         end
end
figure
imshow(img_rgb);
out=shadow_SB(shadow_gray);
title('left-right R=1');
%% 填充阴影 R=2
[row,col]=size(tatistic_data);
shadow_gray=zeros(row*patch_size,col*patch_size);
for i=4:r_0+3
    for j=4:c_0+3
         if patch_sum_R_2(i,j)<10&patch_sum_R_2(i,j)>0  %patch_sum_R_2(i,j)<10&patch_sum_R_2(i,j)>0
            k_x_1= find(left_right(1,:)==(i-4));
            k_y_1 = find(left_right(2,:)==(j-4));
            result_1=ismember(k_y_1,k_x_1);
            for m=1:size(result_1,2)
                if result_1(m)==1
                    ii=floor(k_y_1(m)/(col-1));
                    jj=mod(k_y_1(m),(col-1));
                    if jj==0
                        jj=col-1;
                        ii=ii-1;
                    end
                    shadow_gray((ii*patch_size)+1:(ii+1)*patch_size,(jj-1)*patch_size+1:(jj+1)*patch_size)=1;
                end
            end
            
         elseif patch_sum_R_2(i,j)>=10&patch_sum_R_2(i,j)<20
            k_x_1= find(left_right(1,:)==(i-4));
            k_y_1 = find(left_right(2,:)==(j-4));
            result_1=ismember(k_y_1,k_x_1);
            for m=1:size(result_1,2)
                if result_1(m)==1
                    ii=floor(k_y_1(m)/(col-1));
                    jj=mod(k_y_1(m),(col-1));
                    if jj==0
                        jj=col-1;
                        ii=ii-1;
                    end
                    shadow_gray((ii*patch_size)+1:(ii+1)*patch_size,(jj-1)*patch_size+1:(jj+1)*patch_size)=2;
                end
            end
            
         elseif patch_sum_R_2(i,j)>=20
            k_x_1= find(left_right(1,:)==(i-4));
            k_y_1 = find(left_right(2,:)==(j-4));
            result_1=ismember(k_y_1,k_x_1);
            for m=1:size(result_1,2)
                if result_1(m)==1
                    ii=floor(k_y_1(m)/(col-1));
                    jj=mod(k_y_1(m),(col-1));
                    if jj==0
                        jj=col-1;
                        ii=ii-1;
                    end
                    shadow_gray((ii*patch_size)+1:(ii+1)*patch_size,(jj-1)*patch_size+1:(jj+1)*patch_size)=3;
                end
            end
            
         end
         end
end
figure
imshow(img_rgb);
out=shadow_SB(shadow_gray);
title('left-right R=2');
%% 填充阴影 R=3
[row,col]=size(tatistic_data);
shadow_gray=zeros(row*patch_size,col*patch_size);
for i=4:r_0+3
    for j=4:c_0+3
         if patch_sum_R_3(i,j)<15&patch_sum_R_3(i,j)>0
            k_x_1= find(left_right(1,:)==(i-4));
            k_y_1 = find(left_right(2,:)==(j-4));
            result_1=ismember(k_y_1,k_x_1);
            for m=1:size(result_1,2)
                if result_1(m)==1
                    ii=floor(k_y_1(m)/(col-1));
                    jj=mod(k_y_1(m),(col-1));
                    if jj==0
                        jj=col-1;
                        ii=ii-1;
                    end
                    shadow_gray((ii*patch_size)+1:(ii+1)*patch_size,(jj-1)*patch_size+1:(jj+1)*patch_size)=1;
                end
            end
            
         elseif patch_sum_R_3(i,j)>=15&patch_sum_R_3(i,j)<30
            k_x_1= find(left_right(1,:)==(i-4));
            k_y_1 = find(left_right(2,:)==(j-4));
            result_1=ismember(k_y_1,k_x_1);
            for m=1:size(result_1,2)
                if result_1(m)==1
                    ii=floor(k_y_1(m)/(col-1));
                    jj=mod(k_y_1(m),(col-1));
                    if jj==0
                        jj=col-1;
                        ii=ii-1;
                    end
                    shadow_gray((ii*patch_size)+1:(ii+1)*patch_size,(jj-1)*patch_size+1:(jj+1)*patch_size)=2;
                end
            end
            
         elseif patch_sum_R_3(i,j)>=30
            k_x_1= find(left_right(1,:)==(i-4));
            k_y_1 = find(left_right(2,:)==(j-4));
            result_1=ismember(k_y_1,k_x_1);
            for m=1:size(result_1,2)
                if result_1(m)==1
                    ii=floor(k_y_1(m)/(col-1));
                    jj=mod(k_y_1(m),(col-1));
                    if jj==0
                        jj=col-1;
                        ii=ii-1;
                    end
                    shadow_gray((ii*patch_size)+1:(ii+1)*patch_size,(jj-1)*patch_size+1:(jj+1)*patch_size)=3;
                end
            end
            
         end
         end
end
figure
imshow(img_rgb);
out=shadow_SB(shadow_gray);
title('left-right R=3');
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
%% 散点聚类   left to right
% 填充阴影
shadow_gray=zeros(row*patch_size,col*patch_size);
%%  0<x<12;0<y<12
k_x_0= find(left_right(1,:)<12);
k_y_0 = find(left_right(2,:)<12);
result_0=ismember(k_y_0,k_x_0);
for m=1:size(result_0,2)
    if result_0(m)==1
        i=floor(k_y_0(m)/(col-1));
        j=mod(k_y_0(m),(col-1));
        if j==0
            j=col-1;
            i=i-1;
        end
        shadow_gray((i*patch_size)+1:(i+1)*patch_size,(j-1)*patch_size+1:(j+1)*patch_size)=1;
    end
end
%% 
k_x_1= find(left_right(1,:)>14&left_right(1,:)<=25);
k_y_1 = find(left_right(2,:)>14&left_right(2,:)<=25);
result_1=ismember(k_y_1,k_x_1);
for m=1:size(result_1,2)
    if result_1(m)==1
        i=floor(k_y_1(m)/(col-1));
        j=mod(k_y_1(m),(col-1));
        if j==0
            j=col-1;
            i=i-1;
        end
        shadow_gray((i*patch_size)+1:(i+1)*patch_size,(j-1)*patch_size+1:(j+1)*patch_size)=2;
    end
end
%%
k_x_2= find(left_right(1,:)>25&left_right(1,:)<=35);
k_y_2 = find(left_right(2,:)>14&left_right(2,:)<=25);
result_2=ismember(k_y_2,k_x_2);
for m=1:size(result_2,2)
    if result_2(m)==1
        i=floor(k_y_2(m)/(col-1));
        j=mod(k_y_2(m),(col-1));
        if j==0
            j=col-1;
            i=i-1;
        end
        shadow_gray((i*patch_size)+1:(i+1)*patch_size,(j-1)*patch_size+1:(j+1)*patch_size)=3;
    end
end
%%
k_x_3= find(left_right(1,:)>=20&left_right(1,:)<=35);
k_y_3 = find(left_right(2,:)>25);
result_3=ismember(k_y_3,k_x_3);
for m=1:size(result_3,2)
    if result_3(m)==1
        i=floor(k_y_3(m)/(col-1));
        j=mod(k_y_3(m),(col-1));
        if j==0
            j=col-1;
            i=i-1;
        end
        shadow_gray((i*patch_size)+1:(i+1)*patch_size,(j-1)*patch_size+1:(j+1)*patch_size)=4;
    end
end
%%
k_x_4= find(left_right(1,:)<15);
k_y_4 = find(left_right(2,:)>=15);
result_4=ismember(k_y_4,k_x_4);
for m=1:size(result_4,2)
    if result_4(m)==1
        i=floor(k_y_4(m)/(col-1));
        j=mod(k_y_4(m),(col-1));
        if j==0
            j=col-1;
            i=i-1;
        end
        shadow_gray((i*patch_size)+1:(i+1)*patch_size,(j-1)*patch_size+1:(j+1)*patch_size)=5;
    end
end
%%
k_x_5= find(left_right(1,:)>20);
k_y_5= find(left_right(2,:)<15);
result_5=ismember(k_y_5,k_x_5);
for m=1:size(result_5,2)
    if result_5(m)==1
        i=floor(k_y_5(m)/(col-1));
        j=mod(k_y_5(m),(col-1));
        if j==0
            j=col-1;
            i=i-1;
        end
        shadow_gray((i*patch_size)+1:(i+1)*patch_size,(j-1)*patch_size+1:(j+1)*patch_size)=6;
    end
end
%%
figure
imshow(img_rgb);
out=shadow_SB(shadow_gray);
title('left-right');
%% 利用k-means聚类
[output]=k_means(left_right',4);
figure
for i=1:length(output)
    if output(i)==1
        hold on
        scatter(left_right(1,i),left_right(2,i),'*r'); %线性，颜色，标记
    elseif output(i)==2
        hold on
        scatter(left_right(1,i),left_right(2,i),'*g'); %线性，颜色，标记
    elseif output(i)==3
        hold on
        scatter(left_right(1,i),left_right(2,i),'*b'); %线性，颜色，标记
    else output(i)==4
        hold on
        scatter(left_right(1,i),left_right(2,i),'*y'); %线性，颜色，标记
    end
end
hold off
%--------------------------------------------------------------------------------------------
%% up to down  聚类
l_x= find(up_down(1,:)>25&up_down(1,:)<30);
l_y = find(up_down(2,:)>=20&up_down(2,:)<23);
result0=ismember(l_y,l_x);
%%
shadow_gray_up_down=ones(row*patch_size,col*patch_size);
for m=1:size(result0,2)
    if result0(m)==1
        i=floor(l_y(m)/col);
        j=mod(l_y(m),col);
        if j==0
            j=col;
            i=i-1;
        end
        shadow_gray_up_down((i*patch_size)+1:(i+2)*patch_size,(j-1)*patch_size+1:j*patch_size)=0;
    end
end
figure
imshow(img_original);
out=shadow(shadow_gray_up_down,1);