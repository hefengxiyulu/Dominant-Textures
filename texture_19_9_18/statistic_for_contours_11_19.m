%%
% 2019��11��19�� 
%��������Ҫ�漰���²�����
%ʹ��matlab����L0�˲�ͼ��Ȼ��ʹ��opencv��ȡͼ�����������ʹ�÷ֿ鴦����ȡ����ͼ�нṹ�ķ���仯����ͳ�Ƹ����������ݺ͵�ֱ��ͼ��
%%
close all
addpath(genpath(pwd));
%% input the picture
[FileName, FilePath]=uigetfile('*.jpg;*.png;*.tif;*.img;*.bmp;*.gif;','��ѡ��ͼ������');
str=[FilePath FileName];
img_rgb=imread(str);
img_original=imread('\images\0.bmp'); %%input original image
%% convert to gray image
img_gray=rgb2gray(img_rgb);
img_gray(img_gray<100)=0;
%%
temp_img_gray=double(img_gray);       %% convert to double type
temp_img_gray(temp_img_gray>100)=1;   %% ����������ת��Ϊ1������ʹ�ú���ͳ�ƿ���������ĸ�������ͳ��1���ܸ���
%% ͼ����ת
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
plot(stbl(:,1),stbl(:,2)); %���ԣ���ɫ�����
xlabel('��͵�ֵ');  %x����������
ylabel('ͳ����');
title_name=strcat(num2str(patch_size_x),'x', num2str(patch_size_y),'���ͳ��ͼ');
title(title_name);
set(0,'defaultfigurecolor','w');
set(gca,'XTick',0:1:17);
%%
[max_index_r max_index_c]=find(stbl(:,2)==max(stbl(:,2)));
max_value=stbl(max_index_r,1);
[sort_stbl_data,org_index]=sortrows(stbl,-2);       % ��������������
%%  ɢ��ӳ��
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
title_name=strcat(num2str(patch_size_x),'x', num2str(patch_size_y),'���ӳ��ͼ');
title(title_name);
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ���´���Ϊ����Ϊ1��ͳ�ƴ���
%% ����Ϊ1�ĵ�ͳ��
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
plot(stbl(:,1),stbl(:,2)); %���ԣ���ɫ�����
xlabel('��͵�ֵ');  %x����������
ylabel('ͳ����');
title_name=strcat(num2str(patch_size_x),'x', num2str(patch_size_y),'���ͳ��ͼ');
title(title_name);
set(0,'defaultfigurecolor','w');
set(gca,'XTick',0:1:17);
%% ����
[sort_stbl_data,org_index]=sortrows(stbl,-2);       % ��������������
%% ɢ��ӳ��
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
title_name=strcat(num2str(patch_size_x),'x', num2str(patch_size_y),'���ӳ��ͼ');
title(title_name);