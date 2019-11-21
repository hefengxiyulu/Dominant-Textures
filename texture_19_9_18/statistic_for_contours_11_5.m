%%
% 2019��11��5�� 
%ʹ��opencvѰ�ҵ�������������ΪͼƬ��Ȼ����matlab�е��롣�����зֿ鴦��ͳ��ÿ�������������صĸ�����
%10.30��ͳ�Ƶ�Ϊleft-right�����δ���up-down
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
% figure
% imshow(img_gray);
%%
temp_img_gray=double(img_gray);       %% convert to double type
temp_img_gray(temp_img_gray>100)=1;   %% ����������ת��Ϊ1������ʹ�ú���ͳ�ƿ���������ĸ�������ͳ��1���ܸ���
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
scatter(up_down(1,:),up_down(2,:),'*g'); %���ԣ���ɫ�����
xlabel('up data');  %x����������
ylabel('down data');
set(0,'defaultfigurecolor','w');
%% ����k-means����
[output]=k_means(up_down',4);
figure
for i=1:length(output)
    if output(i)==1
        hold on
        scatter(up_down(1,i),up_down(2,i),'*r'); %���ԣ���ɫ�����
    elseif output(i)==2
        hold on
        scatter(up_down(1,i),up_down(2,i),'*g'); %���ԣ���ɫ�����
    elseif output(i)==3
        hold on
        scatter(up_down(1,i),up_down(2,i),'*b'); %���ԣ���ɫ�����
    else output(i)==4
        hold on
        scatter(up_down(1,i),up_down(2,i),'*c'); %���ԣ���ɫ�����
    end
end
xlabel('up data');  %x����������
ylabel('down data');
title('K-means');
hold off
%%  ɢ��ӳ��
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
%% ͳ��ÿ��ɢ����Χ����ɢ����ܶ�
[big_num]=max(up_down,[],2);
sta_frequency=zeros(big_num(1)+1,big_num(2)+1);       %%��1��Ϊ�˴洢0��������ֵ����1
for len=1:length(up_down)
    sta_frequency(up_down(1,len)+1,up_down(2,len)+1)=sta_frequency(up_down(1,len)+1,up_down(2,len)+1)+1;
end
%% ��ά��״ͼ��ʾ
figure
bar3(sta_frequency)
title('Frequency chart')
%% DBSCAN
out_Idx=my_DBScan(up_down(:,:)',1,2);  %%KNN k distance graph, to determine the epsilon
%%
[row,col]=size(tatistic_data);
out=texture_map(img_rgb,row,col,patch_size,out_Idx,1);
%%