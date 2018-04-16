close all
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
%%
out_parameter=Calculation_Parameters(temp_abs_gray_gradient);
% [out1,out2,out3,out4,out5,out6]=Buchsbaum_implementation(img_rgb);
[out1,out2,out3,out4,out5,out6]=Buchsbaum_implementation(im2uint8(out_final_gray));
%%
% temp_abs_gray_gradient(find(temp_abs_gray_gradient<60))=0;%Modify the threshold to get a different gradient map
% temp_abs_gray_gradient(find(temp_abs_gray_gradient<out_parameter(1,2)))=0;
temp_abs_gray_gradient=temp_abs_gray_gradient.*(uint8(~out6));
figure
subplot(1,2,1);
imshow(temp_abs_gray_gradient);
title('Thresholded image');
subplot(1,2,2);
imshow(im2uint8(out_final_gray));
title('Gradient image');
set(gcf,'color','w');
%%
% compared the width and length of the image to obtain the smaller
% dimension,represented by min_value. We then set the edge lengths of
% patches to 2%×lp, 4%×lp, ..., 10%×lp, and 12%×lp, respectively.
[length_img,width_img]=size(temp_abs_gray_gradient);
min_value=min(length_img,width_img);

patch_size=ceil(min_value*0.1);

% patch_size=out_parameter(1,4);

% imwrite(vary_abs_gray_gradient,'first_gradient.bmp');
%% 
temp_vary_abs_gray_gradient=temp_abs_gray_gradient;
temp_vary_abs_gray_gradient(find(temp_vary_abs_gray_gradient>0))=1;
%%
figure
imshow(double(temp_vary_abs_gray_gradient));
title('Binary gradient image');
set(gcf,'color','w');
%%
offset=0;% offset number

% offset=out_parameter(1,3);
temp_input=temp_vary_abs_gray_gradient(:,offset+1:end);
statistic_data_gradient=blkproc(temp_input,[patch_size patch_size],'sum2');% Select the appropriate batch size
% statistic_data_gradient=blkproc(temp_input,[4 4],'sum2');% Select the appropriate batch size
max_gradient_value=max(max(statistic_data_gradient));                      % find the max number
[x,y]=find(statistic_data_gradient==max(max(max_gradient_value)));         % find the location of the max number
same_sum_gradient_num=zeros(1,max_gradient_value);                         %statistics the same distance
for i_1=1:max_gradient_value
same_sum_gradient_num(1,i_1)=length(find(statistic_data_gradient==i_1));
end
figure
plot(same_sum_gradient_num);
title('Statistic figure of batch gradient');
xlabel('X轴-块内数字1的和');
ylabel('Y轴-和相同时块的个数');
set(gcf,'color','w');
%% Find the max value and the location in the array
[max_valeue,location_num]=max(same_sum_gradient_num);
len_num= length(same_sum_gradient_num);  % number of the elements
threshold_value=len_num/3;
%%  curve fitting
figure
x_curve=linspace(1,len_num,len_num);
y_curve=same_sum_gradient_num;
%%%
p_2=polyfit(x_curve,y_curve,2);
y2=polyval(p_2,x_curve);
%%%
p_3=polyfit(x_curve,y_curve,3);
y3=polyval(p_3,x_curve);
%%%
plot(x_curve,y_curve,':o',x_curve,y2,'--g',x_curve,y3,'-*') ;
legend('original','2-fit','3-fit') ;
title('曲线拟合');
set(gcf,'color','w');
Euc_distance= pdist2(y2,y3,'Euclidean');%calculate euclidean distance
%% calculate  slope 
 sum_slope=0;
for ii=1:len_num-1
    temp_slope=same_sum_gradient_num(ii+1)-same_sum_gradient_num(ii);
    sum_slope=sum_slope+temp_slope;
end

%%
% if (location_num<threshold_value)
%     out=processing_natural_image(img_rgb);
% else

% % if (sum_slope<0)
% %     out=processing_natural_image(img_rgb);
% else
%% show the texture by the batch statistic
out_range=range_point(same_sum_gradient_num);
%%
sum_value=sum(same_sum_gradient_num);
l_p=out_range(2,1);
r_p=out_range(2,2);
partial_sum=sum(same_sum_gradient_num(l_p:r_p));
ratio_value=partial_sum/sum_value;
%%
dominant_length=location_num;
total_length=len_num;
weight_fusion=dominant_length/total_length;
%%
% The number of batch size must be the same size as the above-mentioned processing 
block_texture=gradient_texture(temp_input,statistic_data_gradient,out_range,patch_size);
[ro_temp,co_temp]=size(block_texture);
tiep_add_column=zeros(ro_temp,offset);
block_texture=[tiep_add_column block_texture];
figure
imshow(img_rgb);
hold on
out=shadow(block_texture,1);
title('gray-image-teture');
hold off
%% save the block_texture value thus compute the patch to be marked times show the times>2 corresponding patch
% block_texture_3=block_texture;
% block_texture_5=block_texture;
% block_texture_7=block_texture;
% block_texture_10=block_texture;
% block_texture_15=block_texture;
%%
% block_texture_2=block_texture;
% block_texture_4=block_texture;
% block_texture_5=block_texture;
% block_texture_7=block_texture;
% block_texture_9=block_texture;
block_texture_10=block_texture;
%%
% mark_out=mark_fusion(img_rgb,block_texture_3,block_texture_5,block_texture_7,block_texture_10,block_texture_15);
% mark_out=mark_fusion(img_rgb,block_tex0ture_2,block_texture_4,block_texture_5,block_texture_7,block_texture_9,block_texture_10);
% end

%%  final two methods fusion

