%%
% ������2019��11��7��
% statistic_for_contours_10_30.m���滻�汾������ԭ�汾�к��й�������֤��ʧ�ܵĴ��룬��˸ð汾Ϊԭ����ĸĽ��棬��ҪӦ��DBScan�����㷨����ɢ��ľ��ࡣ
%ʹ��opencvѰ�ҵ�������������ΪͼƬ��Ȼ����matlab�е��롣�����зֿ鴦��ͳ��ÿ�������������صĸ�����
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
figure
imshow(img_gray);
%%
temp_img_gray=double(img_gray);       %% convert to double type
temp_img_gray(temp_img_gray>100)=1;   %% ����������ת��Ϊ1������ʹ�ú���ͳ�ƿ���������ĸ�������ͳ��1���ܸ���
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
scatter(left_right(1,:),left_right(2,:),'*b'); %���ԣ���ɫ�����
xlabel('left data');  %x����������
ylabel('right data');
set(0,'defaultfigurecolor','w');
%% ͳ��ÿ��ɢ����Χ����ɢ����ܶ�
[big_num]=max(left_right,[],2);
sta_frequency=zeros(big_num(1)+1,big_num(2)+1);       %%��1��Ϊ�˴洢0��������ֵ����1
for len=1:length(left_right)
    sta_frequency(left_right(1,len)+1,left_right(2,len)+1)=sta_frequency(left_right(1,len)+1,left_right(2,len)+1)+1;
end
%% ��ά��״ͼ��ʾ
figure
bar3(sta_frequency)
title('Frequency chart')
%% DBSCAN
out_Idx=my_DBScan(left_right(:,:)',1,2);  %%KNN k distance graph, to determine the epsilon
%%
[row,col]=size(tatistic_data);
out=texture_map(img_rgb,row,col,patch_size,out_Idx,0);