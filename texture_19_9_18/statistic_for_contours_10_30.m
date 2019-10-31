%%
% 2019��10��30�� 
%ʹ��opencvѰ�ҵ�������������ΪͼƬ��Ȼ����matlab�е��롣�����зֿ鴦��ͳ��ÿ�������������صĸ�����
%%
close all
addpath(genpath(pwd));
%% input the picture
[FileName, FilePath]=uigetfile('*.jpg;*.png;*.tif;*.img;*.bmp;*.gif;','��ѡ��ͼ������');
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
temp_img_gray(temp_img_gray>100)=1;   %% ����������ת��Ϊ1������ʹ�ú���ͳ�ƿ���������ĸ�������ͳ��1���ܸ���
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
scatter(left_right(1,:),left_right(2,:),'*b'); %���ԣ���ɫ�����
%plot(left_right(1,:),left_right(2,:)); %���ԣ���ɫ�����
% xlabel('�ݶ�ֵ');  %x����������
% ylabel('ͳ����');
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
scatter(up_down(1,:),up_down(2,:),'*g'); %���ԣ���ɫ�����
%plot(left_right(1,:),left_right(2,:)); %���ԣ���ɫ�����
% xlabel('�ݶ�ֵ');  %x����������
% ylabel('ͳ����');
set(0,'defaultfigurecolor','w');
