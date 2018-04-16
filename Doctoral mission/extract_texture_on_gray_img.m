addpath(genpath(pwd));
%% input the picture
[FileName, FilePath]=uigetfile('*.jpg;*.png;*.tif;*.img;*.bmp;*.gif;','请选择图像数据');
str=[FilePath FileName];
img_rgb=imread(str);
%%
img_gray=rgb2gray(img_rgb);
temp_img_gray=img_gray;
temp_img_gray=im2double(temp_img_gray);
[out_row_gray,out_colum_gray,out_final_gray]=Gradient_calculation(temp_img_gray);%Calculate the gradient
temp_abs_gray_gradient=im2uint8(out_final_gray);
temp_abs_gray_gradient(find(temp_abs_gray_gradient<50))=0;%Modify the threshold to get a different gradient map
figure
subplot(1,2,1);
imshow(temp_abs_gray_gradient);
title('Thresholded image');
subplot(1,2,2);
imshow(im2uint8(out_final_gray));
title('Gradient image');
set(gcf,'color','w');
%% 
[m,n]=size(temp_abs_gray_gradient);
statistic_row_value=zeros(m,ceil(n/2));
statistic_column_value=zeros(n,ceil(m/2));
%% compute the row distance of each interval and  Record the position between each interval
for i=1:m
    count_1=0;
    count_2=0;
    count_3=0;
    for j=1:n
        if(temp_abs_gray_gradient(i,j)>0&&j<n&&temp_abs_gray_gradient(i,j+1)==0)
            count_1=0;
            count_2=count_2+1;
            count_3=1;
            statistic_row_value(i,count_2)=j;
        end
        if(j<n&&j>1&&temp_abs_gray_gradient(i,j+1)>0&&temp_abs_gray_gradient(i,j)==0&&count_3==1)
            count_2=count_2+1; 
            statistic_row_value(i,count_2)=j+1;
            count_3=0;
        end
    end
end
 distance_row=zeros(m,floor(n/4));
for ii=1:floor(n/4)
    distance_row(:,ii)=statistic_row_value(:,ii*2)-statistic_row_value(:,ii*2-1);
end
distance_row(distance_row<0)=0;% Remove negative numbers
max_row_value=max(max(distance_row));% find the max number
[x,y]=find(distance_row==max(max(distance_row))); % find the location of the max number
same_row_distance_num=zeros(1,max_row_value);%statistics the same distance
for iii=1:max_row_value
same_row_distance_num(1,iii)=length(find(distance_row==iii));
end
figure
% plot(same_row_distance_num);
bar(same_row_distance_num,0.2);
title('Statistic figure of row number');
set(gcf,'color','w');
%% show the corresponding texture (row distance statistic)
[max_row_distance,index_row]=max(same_row_distance_num);
[ro,col]=size(temp_abs_gray_gradient);%Get the original gradient image size
temp_correspond_texture_region_row=ones(ro,col);% Create an all 1 matrix,size is equal to the original size
[value_sort,index_sort] = sort(same_row_distance_num);%Sort the numbers of same_row_distance_num
row_value_sort=value_sort;
row_index_sort=index_sort;
[ro_115,col_115]=size(value_sort);
for i_115=col_115-5:col_115
[v_row,v_column]=find(distance_row==index_sort(1,i_115));% find the max distance number in the corresponding gradient iamge
%[r_1,c_1]=size(v_row);
for ii_1=1:value_sort(1,i_115)
    row_1=v_row(ii_1);
    col_1=v_column(ii_1);
    % find the location from starting point to the ending point
    temp_1=statistic_row_value(row_1,2*col_1-1);
    temp_2=statistic_row_value(row_1,2*col_1);
    for ii_2=temp_1:temp_2
        temp_correspond_texture_region_row(row_1,ii_2)=0;
    end
end
end
figure
imshow(img_rgb);
hold on
out_row=shadow(temp_correspond_texture_region_row,1);
title('Gray-Row-纹理图像');
hold off
%% compute column ....
temp_gradient=temp_abs_gray_gradient';
for i=1:n
    count_1=0;
    count_2=0;
    count_3=0;
    for j=1:m
        if(temp_gradient(i,j)>0&&j<m&&temp_gradient(i,j+1)==0)
            count_1=0;
            count_2=count_2+1;
            count_3=1;
            statistic_column_value(i,count_2)=j;
        end
        if(j<m&&j>1&&temp_gradient(i,j+1)>0&&temp_gradient(i,j)==0&&count_3==1)
            count_2=count_2+1; 
            statistic_column_value(i,count_2)=j+1;
            count_3=0;
        end
    end
end
distance_column=zeros(n,floor(m/4));
for ii=1:floor(m/4)
    distance_column(:,ii)=statistic_column_value(:,ii*2)-statistic_column_value(:,ii*2-1);
end
distance_column(distance_column<0)=0; % Remove negative numbers
max_column_value=max(max(distance_column)); % find the max number
[x,y]=find(distance_column==max(max(distance_column))); % find the location of the max number
same_column_distance_num=zeros(1,max_column_value);%statistics the same distance
for iii=1:max_column_value
same_column_distance_num(1,iii)=length(find(distance_column==iii));
end
figure
% plot(same_column_distance_num);
bar(same_column_distance_num,0.2);
title('Statistic figure of column number');
set(gcf,'color','w');
 %% show the corresponding texture (column distance statistic)
[max_column_distance,index_column]=max(same_column_distance_num);
[ro,col]=size(temp_abs_gray_gradient);
temp_correspond_texture_region_column=ones(col,ro);
[value_sort,index_sort] = sort(same_column_distance_num);%Sort the numbers of same_row_distance_num
column_value_sort=value_sort;
column_index_sort=index_sort;
[ro_115,col_115]=size(value_sort);
for i_115=col_115-5:col_115
[v_row,v_column]=find(distance_column==index_sort(1,i_115));% find the max distance number in the corresponding gradient iamge
%[r_1,c_1]=size(v_row);
for ii_3=1:value_sort(1,i_115)
    row_2=v_row(ii_3);
    col_2=v_column(ii_3);
    % find the location from starting point to the ending point
    temp_1=statistic_column_value(row_2,2*col_2-1);
    temp_2=statistic_column_value(row_2,2*col_2);
    for ii_4=temp_1:temp_2
        temp_correspond_texture_region_column(row_2,ii_4)=0;
    end
end
end
figure
imshow(img_rgb);
hold on
out_column=shadow(temp_correspond_texture_region_column',1);
title('Gray-Column-纹理图像');
hold off
%% The same area marker fusion
figure
imshow(img_rgb);
hold on
out_column=shadow(temp_correspond_texture_region_column',1);
hold on
out_row=shadow(temp_correspond_texture_region_row,1);
title('Gray-纹理图像');
hold off
%%
% compared the width and length of the image to obtain the smaller
% dimension,represented by min_value. We then set the edge lengths of
% patches to 2%×lp, 4%×lp, ..., 10%×lp, and 12%×lp, respectively.
[length_img,width_img]=size(temp_abs_gray_gradient);
min_value=min(length_img,width_img);
% patch_size=ceil(min_value*0.06);
patch_size=5;
% imwrite(vary_abs_gray_gradient,'first_gradient.bmp');
%% 
temp_vary_abs_gray_gradient=temp_abs_gray_gradient;
temp_vary_abs_gray_gradient(find(temp_vary_abs_gray_gradient>0))=1;
%%%%
figure
imshow(double(temp_vary_abs_gray_gradient));
title('Binary gradient image');
set(gcf,'color','w');
%%
% convo_kernel=ones(patch_size,patch_size);
% convo_statistic_data_gradient=conv2(temp_vary_abs_gray_gradient,convo_kernel,'valid');
% convo_max_gradient_value=max(max(convo_statistic_data_gradient));% find the max number
% convo_same_sum_gradient_num=zeros(1,convo_max_gradient_value);%statistics the same distance
% for i_1=1:convo_max_gradient_value
% convo_same_sum_gradient_num(1,i_1)=length(find(convo_statistic_data_gradient==i_1));
% end
%%%%%
[out_convo,convo_statistic_data_gradient]=convolution_compute(temp_vary_abs_gray_gradient,patch_size);
figure
plot(out_convo);
title('Convolution statistic figure of batch gradient');
set(gcf,'color','w');
%% convolution 
out_convo_range=range_point(out_convo);
convo_block_texture=convolution_texture(temp_abs_gray_gradient,convo_statistic_data_gradient,out_convo_range,patch_size);
figure
imshow(img_rgb);
hold on
out=shadow(convo_block_texture,1);
title('gray-image-teture');
hold off
%%
statistic_data_gradient=blkproc(temp_vary_abs_gray_gradient,[patch_size patch_size], 'sum2');%Select the appropriate batch size
max_gradient_value=max(max(statistic_data_gradient));% find the max number
[x,y]=find(statistic_data_gradient==max(max(max_gradient_value))); % find the location of the max number
same_sum_gradient_num=zeros(1,max_gradient_value);%statistics the same distance
for i_1=1:max_gradient_value
same_sum_gradient_num(1,i_1)=length(find(statistic_data_gradient==i_1));
end
figure
plot(same_sum_gradient_num);
title('Statistic figure of batch gradient');
xlabel('X轴-块内数字1的和');
ylabel('Y轴-和相同时块的个数');
set(gcf,'color','w');
%% show the texture by the batch statistic
out_range=range_point(same_sum_gradient_num);
% The number of batch size must be the same size as the above-mentioned processing 
block_texture=gradient_texture(temp_abs_gray_gradient,statistic_data_gradient,out_range,patch_size);
figure
imshow(img_rgb);
hold on
out=shadow(block_texture,1);
title('gray-image-teture');
hold off
%% save the block_texture value thus compute the patch to be marked times show the times>2 corresponding patch
block_texture_5=block_texture;
% block_texture_10=block_texture;
% block_texture_15=block_texture;
% block_texture_20=block_texture;
% block_texture_25=block_texture;

% block_texture_3=block_texture;
% block_texture_4=block_texture;
% block_texture_5=block_texture;
% block_texture_6=block_texture;
% block_texture_7=block_texture;
% block_texture_9=block_texture;
% block_texture_10=block_texture;
% block_texture_12=block_texture;
%%
% mark_out=mark_fusion(img_rgb,block_texture_3,block_texture_5,block_texture_7,block_texture_10,block_texture_15);
%%
% block_texture_total=block_texture_5+block_texture_10+block_texture_15+block_texture_20;
% block_texture_total=block_texture_3+block_texture_6+block_texture_9+block_texture_12+block_texture_15;
% 
% temp_block_texture_total=block_texture_total;
% block_texture_total(find(block_texture_total<=3))=0;
% figure
% imshow(img_rgb);
% hold on
% out=shadow(block_texture_total,1);
% title('gray-image-teture');
% hold off
% %
% temp_block_texture_total(find(temp_block_texture_total>3))=0;
% figure
% imshow(img_rgb);
% hold on
% out=shadow(temp_block_texture_total,1);
% title('gray-image-teture');
% hold off