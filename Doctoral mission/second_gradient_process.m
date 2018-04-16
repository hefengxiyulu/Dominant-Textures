addpath(genpath(pwd));
[FileName, FilePath]=uigetfile('*.jpg;*.png;*.tif;*.img;*.bmp;*.gif;','ÇëÑ¡ÔñÍ¼ÏñÊý¾Ý');
str=[FilePath FileName];
img_gradient=imread(str);
[out_row_gray,out_colum_gray,out_final_gray]=Gradient_calculation(img_gradient);
second_gradient_img=uint8(out_final_gray);

% compared the width and length of the image to obtain the smaller
% dimension,represented by min_value. We then set the edge lengths of
% patches to 2%¡Álp, 4%¡Álp, ..., 10%¡Álp, and 12%¡Álp, respectively.
[length_img,width_img]=size(second_gradient_img);
min_value=min(length_img,width_img);
patch_size=ceil(min_value*0.02);

second_gradient_img(find(second_gradient_img<50))=0;%Modify the threshold to get a different gradient map
figure
imshow(second_gradient_img);
set(gcf,'color','w');
title('Gradient image');
img_rgb=imread('0.bmp');
%%
temp_second_gradient_img=second_gradient_img;
temp_second_gradient_img(find(temp_second_gradient_img>0))=1;
figure
imshow(double(temp_second_gradient_img));
title('Binary gradient graph');
statistic_data_gradient=blkproc(temp_second_gradient_img,[patch_size patch_size], 'sum2');%Select the appropriate batch size
max_gradient_value=max(max(statistic_data_gradient));% find the max number
[x,y]=find(max_gradient_value==max(max(max_gradient_value))); % find the location of the max number
same_sum_gradient_num=zeros(1,max_gradient_value);%statistics the same distance
for i_1=1:max_gradient_value
same_sum_gradient_num(1,i_1)=length(find(statistic_data_gradient==i_1));
end
figure
plot(same_sum_gradient_num);
title('Statistic figure of batch gradient');
set(gcf,'color','w');
%% show the texture by the batch statistic
out_range=range_point(same_sum_gradient_num);
% The number of batch size must be the same size as the above-mentioned processing 
block_texture=gradient_texture(second_gradient_img,statistic_data_gradient,out_range,patch_size);
figure
imshow(img_rgb);
hold on
out=shadow(block_texture,1);
title('gray-image-teture');
hold off
%% save the block_texture value thus compute the patch to be marked times show the times>2 corresponding patch
% block_texture_5=block_texture;
% block_texture_10=block_texture;
% block_texture_15=block_texture;
% block_texture_20=block_texture;

block_texture_2=block_texture;
% block_texture_4=block_texture;
% block_texture_5=block_texture;
% block_texture_7=block_texture;
% block_texture_9=block_texture;
% block_texture_10=block_texture;
% block_texture_12=block_texture;

% block_texture_total=block_texture_5+block_texture_10+block_texture_15+block_texture_20;
block_texture_total=block_texture_2+block_texture_4+block_texture_5+block_texture_7+block_texture_9+block_texture_10+block_texture_12;
temp_block_texture_total=block_texture_total;
block_texture_total(find(block_texture_total<=3))=0;
figure
imshow(img_rgb);
hold on
out=shadow(block_texture_total,1);
title('gray-image-teture');
hold off
%
temp_block_texture_total(find(temp_block_texture_total>3))=0;
figure
imshow(img_rgb);
hold on
out=shadow(temp_block_texture_total,1);
title('gray-image-teture');
hold off
%%
[m,n]=size(second_gradient_img);
statistic_row_value=zeros(m,ceil(n/2));
statistic_column_value=zeros(n,ceil(m/2));
%% compute the row distance of each interval and  Record the position between each interval
for i=1:m
    count_1=0;
    count_2=0;
    count_3=0;
    for j=1:n
        if(second_gradient_img(i,j)>0&&j<n&&second_gradient_img(i,j+1)==0)
            count_1=0;
            count_2=count_2+1;
            count_3=1;
            statistic_row_value(i,count_2)=j;
        end
        if(j<n&&j>1&&second_gradient_img(i,j+1)>0&&second_gradient_img(i,j)==0&&count_3==1)
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
plot(same_row_distance_num);
title('Statistic figure of row number');
set(gcf,'color','w');
%% show the corresponding texture (row distance statistic)
[max_row_distance,index_row]=max(same_row_distance_num);
[ro,col]=size(second_gradient_img);
temp_correspond_texture_region_row=ones(ro,col);
[v_row,v_column]=find(distance_row==index_row);% find the max distance number in the corresponding gradient iamge
%[r_1,c_1]=size(v_row);
for ii_1=1:max_row_distance
    row_1=v_row(ii_1);
    col_1=v_column(ii_1);
    % find the location from starting point to the ending point
    temp_1=statistic_row_value(row_1,2*col_1-1);
    temp_2=statistic_row_value(row_1,2*col_1);
    for ii_2=temp_1:temp_2
        temp_correspond_texture_region_row(row_1,ii_2)=0;
    end
end
figure
imshow(img_rgb);
hold on
out_row=shadow(temp_correspond_texture_region_row,1);
title('Gray-Row-ÎÆÀíÍ¼Ïñ');
hold off
%% compute column ....
temp_gradient=second_gradient_img';
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
plot(same_column_distance_num);
title('Statistic figure of column number');
set(gcf,'color','w');
 %% show the corresponding texture (column distance statistic)
[max_column_distance,index_column]=max(same_column_distance_num);
[ro,col]=size(second_gradient_img);
temp_correspond_texture_region_column=ones(col,ro);
[v_row,v_column]=find(distance_column==index_column);% find the max distance number in the corresponding gradient iamge
%[r_1,c_1]=size(v_row);
for ii_3=1:max_column_distance
    row_2=v_row(ii_3);
    col_2=v_column(ii_3);
    % find the location from starting point to the ending point
    temp_1=statistic_column_value(row_2,2*col_2-1);
    temp_2=statistic_column_value(row_2,2*col_2);
    for ii_4=temp_1:temp_2
        temp_correspond_texture_region_column(row_2,ii_4)=0;
    end
end
figure
imshow(img_rgb);
hold on
out_column=shadow(temp_correspond_texture_region_column',1);
title('Gray-Column-ÎÆÀíÍ¼Ïñ');
hold off
%%
figure
imshow(img_rgb);
hold on
out_column=shadow(temp_correspond_texture_region_column',1);
hold on
out_row=shadow(temp_correspond_texture_region_row,1);
title('Gray-ÎÆÀíÍ¼Ïñ');
hold off