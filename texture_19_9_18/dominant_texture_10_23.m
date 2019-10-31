%%
% 2019��10��23�� 
%����ͳ���ݶ�ֵ�ķֲ������Ȼ������ݶ�ֵ���з���������ͼ����зֿ飬ͳ�Ƹ������ڰ������������ı�������������Ҫ�����Ŀ�Ϊ��ˮ���㷨�����ӵ㣬������ɢ��
%%
close all
addpath(genpath(pwd));
%% input the picture
[FileName, FilePath]=uigetfile('*.jpg;*.png;*.tif;*.img;*.bmp;*.gif;','��ѡ��ͼ������');
str=[FilePath FileName];
img_rgb=imread(str);
%% convert to gray image
img_gray=rgb2gray(img_rgb);
%% computing the gradient,using 4-neighbourhood/8-nieghbourhood
temp_img_gray=double(img_gray);
[out_row_gray,out_colum_gray,out_final_gray,out_eight_final]=Gradient_calculation(temp_img_gray);%Calculate the gradient out_final_gray:���������;out_eight_final:���������
%% show gradient image
figure
imshow(uint8(out_final_gray));
imwrite(uint8(out_final_gray),'one_gradient.jpg');   %%save img
%%
figure
[c,h]=imcontour(img_gray,3);
%% Statistical gradient value distribution
stbl=tabulate(out_final_gray(:));
figure
[row,col]=size(stbl);
x=1:1:row;%x���ϵ����ݣ���һ��ֵ�������ݿ�ʼ���ڶ���ֵ��������������ֵ������ֹ
plot(x,stbl(:,2)); %���ԣ���ɫ�����
xlabel('�ݶ�ֵ');  %x����������
ylabel('ͳ����');
set(0,'defaultfigurecolor','w');
%% 9*9 patch
[n,m]=size(out_final_gray);
n_0=ceil(n/9);
m_0=ceil(m/9);

matrix_A_region=zeros(n_0,m_0);   %��¼�ݶ�ֵ�ֲ���A�����ͳ��ֵ
matrix_B_region=zeros(n_0,m_0);   %��¼�ݶ�ֵ�ֲ���B�����ͳ��ֵ
matrix_C_region=zeros(n_0,m_0);   %��¼�ݶ�ֵ�ֲ���C�����ͳ��ֵ
matrix_D_region=zeros(n_0,m_0);   %��¼�ݶ�ֵ�ֲ���D�����ͳ��ֵ
matrix_E_region=zeros(n_0,m_0);   %��¼�ݶ�ֵ�ֲ���E�����ͳ��ֵ

temp_gray=zeros(n_0*9,m_0*9);
temp_gray(1:n,1:m)=out_final_gray;
temp_matrix0 = zeros(9);
%%
for i=1:n_0
    for j=1:m_0
        temp_matrix0=temp_gray((1+(i-1)*9):i*9,(1+(j-1)*9):j*9);
        stbl_1=tabulate(temp_matrix0(:));
        matrix_A_region(i,j)=length(find(temp_matrix0<=10));
        matrix_B_region(i,j)=length(find(temp_matrix0>10&temp_matrix0<=20));
        matrix_C_region(i,j)=length(find(temp_matrix0>20&temp_matrix0<=30));
        matrix_D_region(i,j)=length(find(temp_matrix0>30&temp_matrix0<=40));
        matrix_E_region(i,j)=length(find(temp_matrix0>40&temp_matrix0<=50));
    end
end
%%
temp_A_matrix=reshape(matrix_A_region',1,n_0*m_0);
temp_B_matrix=reshape(matrix_B_region',1,n_0*m_0);
temp_C_matrix=reshape(matrix_C_region',1,n_0*m_0);
temp_D_matrix=reshape(matrix_D_region',1,n_0*m_0);
temp_E_matrix=reshape(matrix_E_region',1,n_0*m_0);
%%
figure
hold on
plot(temp_A_matrix,'r-*');
plot(temp_B_matrix,'g-*');
plot(temp_C_matrix,'b-*');
plot(temp_D_matrix,'y-*');
plot(temp_E_matrix,'c-*');

legend('A-region:0~10','B-region:11~20','C-region:21~30','D-region:31~40','E-region:41~50','Location','north');
xlabel('9*9��ĸ���');  %x����������
ylabel('���ڸ���region�����ݵĺ���');  %y����������
hold off
%% ������ݶ�ֵ���֣�
[n,m]=size(out_final_gray);
n_0=ceil(n/9);
m_0=ceil(m/9);

matrix_A2_region=zeros(n_0,m_0);   %��¼�ݶ�ֵ�ֲ���A�����ͳ��ֵ
matrix_B2_region=zeros(n_0,m_0);   %��¼�ݶ�ֵ�ֲ���B�����ͳ��ֵ
matrix_C2_region=zeros(n_0,m_0);   %��¼�ݶ�ֵ�ֲ���C�����ͳ��ֵ
matrix_D2_region=zeros(n_0,m_0);   %��¼�ݶ�ֵ�ֲ���D�����ͳ��ֵ


temp_gray2=zeros(n_0*9,m_0*9);
temp_gray2(1:n,1:m)=out_final_gray;
temp_matrix2 = zeros(9);
%%
for i=1:n_0
    for j=1:m_0
        temp_matrix2=temp_gray2((1+(i-1)*9):i*9,(1+(j-1)*9):j*9);
        stbl_1=tabulate(temp_matrix2(:));
        matrix_A2_region(i,j)=length(find(temp_matrix2>50&temp_matrix2<=100));
        matrix_B2_region(i,j)=length(find(temp_matrix2>100&temp_matrix2<=150));
        matrix_C2_region(i,j)=length(find(temp_matrix2>150&temp_matrix2<=200));
        matrix_D2_region(i,j)=length(find(temp_matrix2>200));
    end
end
%%
temp_A2_matrix=reshape(matrix_A2_region',1,n_0*m_0);
temp_B2_matrix=reshape(matrix_B2_region',1,n_0*m_0);
temp_C2_matrix=reshape(matrix_C2_region',1,n_0*m_0);
temp_D2_matrix=reshape(matrix_D2_region',1,n_0*m_0);
%%
figure
hold on
plot(temp_A2_matrix,'r-*');
plot(temp_B2_matrix,'g-*');
plot(temp_C2_matrix,'b-*');
plot(temp_D2_matrix,'y-*');

legend('A-region:51~100','B-region:101~150','C-region:151~200','D-region:201~...','Location','north');
xlabel('9*9��ĸ���');  %x����������
ylabel('���ڸ���region�����ݵĺ���');  %y����������
hold off
%% Ѱ��ÿ��������Ҫ�ɷ�����������
[k,l]=size(temp_A2_matrix);
index_region=zeros(k,l);
for ii=1:l
    [m,p]=max([temp_A2_matrix(k,ii),temp_B2_matrix(k,ii),temp_C2_matrix(k,ii),temp_D2_matrix(k,ii)]);
    index_region(k,ii)=p;
end
%% �����Ӱ
shadow_img=zeros(n_0*9,m_0*9);
for kk=1:l
    r=rem(kk,m_0);
    f=floor(kk/m_0);
    if r==0
        r=m_0;
        f=f-1;
    end
    shadow_img(1+f*9:(f+1)*9,1+(r-1)*9:r*9)=index_region(1,kk);
end
figure
imshow(img_rgb);
out=shadow_multi(shadow_img);
%%
figure
imshow(img_rgb);
[out_row_gray1,out_colum_gray1,out_final_gray1,out_eight_final1]=Gradient_calculation(out_final_gray);%Calculate the gradient out_final_gray:���������;out_eight_final:���������
out=shadow_point(out_final_gray1);

%---------------------------------------�ָ���----------------------------------------------------
%% 7*7
[n,m]=size(out_final_gray);
n_1=ceil(n/7);
m_1=ceil(m/7);

matrix_A1_region=zeros(n_1,m_1);   %��¼�ݶ�ֵ�ֲ���A�����ͳ��ֵ
matrix_B1_region=zeros(n_1,m_1);   %��¼�ݶ�ֵ�ֲ���B�����ͳ��ֵ
matrix_C1_region=zeros(n_1,m_1);   %��¼�ݶ�ֵ�ֲ���C�����ͳ��ֵ
matrix_D1_region=zeros(n_1,m_1);   %��¼�ݶ�ֵ�ֲ���D�����ͳ��ֵ

temp_gray_1=zeros(n_1*7,m_1*7);
temp_gray_1(1:n,1:m)=out_final_gray;
temp_matrix_1 = zeros(7);
%%
for i=1:n_1
    for j=1:m_1
        temp_matrix0=temp_gray_1((1+(i-1)*7):i*7,(1+(j-1)*7):j*7);
        stbl_1=tabulate(temp_matrix0(:));
        matrix_A1_region(i,j)=length(find(temp_matrix0<=50));
        matrix_B1_region(i,j)=length(find(temp_matrix0>50&temp_matrix0<=100));
        matrix_C1_region(i,j)=length(find(temp_matrix0>100&temp_matrix0<=150));
        matrix_D1_region(i,j)=length(find(temp_matrix0>150));
    end
end
%%
temp_A1_matrix=reshape(matrix_A1_region',1,n_1*m_1);
temp_B1_matrix=reshape(matrix_B1_region',1,n_1*m_1);
temp_C1_matrix=reshape(matrix_C1_region',1,n_1*m_1);
temp_D1_matrix=reshape(matrix_D1_region',1,n_1*m_1);
%%
figure
hold on
plot(temp_A1_matrix,'r-*');
plot(temp_B1_matrix,'g-*');
plot(temp_C1_matrix,'b-*');
plot(temp_D1_matrix,'y-*');
legend('A-region:0~50','B-region:51~100','C-region:101~150','D-region:151~...');
xlabel('7*7��ĸ���');  %x����������
ylabel('���ڸ���region�����ݵĺ���');  %y����������
hold off