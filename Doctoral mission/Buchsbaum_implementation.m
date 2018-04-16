function [out1,out2,out3,out4,out5,out6]=Buchsbaum_implementation(input)

% addpath(genpath(pwd));
% %% input the picture
% [FileName, FilePath]=uigetfile('*.jpg;*.png;*.tif;*.img;*.bmp;*.gif;','��ѡ��ͼ������');
% str=[FilePath FileName];
% img_rgb=imread(str);
img_rgb=input;
%% 
[m n z]=size(img_rgb);
if(z>1)
    img_gray=rgb2gray(img_rgb);
else
    img_gray=img_rgb;
end
%% Background brightness 
[W,H]=size(img_gray);
X_img=zeros(W+2,H+2);
X_img(2:W+1,2:H+1)=img_gray;
for i=2:W+1
    for j=2:H+1
    B_right_direction=1/4*(X_img(i-1,j)+X_img(i+1,j)+X_img(i,j-1)+X_img(i,j+1));%directly left, right, up and down of the pixel
    B_diagonal_line=1/(4*sqrt(2))*(X_img(i-1,j-1)+X_img(i+1,j-1)+X_img(i-1,j+1)+X_img(i+1,j+1));%the pixels diagonally one pixel away
    B(i,j)=1/2*(1/2*(B_right_direction+B_diagonal_line)+X_img(i,j)); % B is the value of brightness 
    end
end
B_brightness= B(2:W+1,2:H+1);
figure
imshow(uint8(B_brightness));
title('��������ͼ');
%% calculate the max pixel value and the min pixel value in a image
min_value=min(min(img_gray));
max_value=max(max(img_gray));
B_t=max_value-min_value;
%% canny edge detect
BW1 = edge(X_img,'canny');  % ����canny����
[out_row_gray,out_colum_gray,out_final_gray_1]=Gradient_calculation(img_gray);
Gradient_value=out_final_gray_1;
figure
imshow(uint8(Gradient_value));
title('�ݶ�ͼ');
%% set parameters
a1=0;
a2=0.3;
a3=0.7;
beta=0.02;
B_x1=a1*B_t;
B_x2=a2*B_t;
B_x3=a3*B_t;
%%
K1=beta/100*max(max(Gradient_value./B_brightness));
K2=K1*sqrt(double(B_x2));
K3=K1/B_x3;
%%
% temp_brightness1=B_brightness;
% temp_brightness1(find(temp_brightness1>=B_x1))=0;
% figure
% imshow(img_rgb);
% hold on;
% out=shadow(temp_brightness1,1);
% title('�ǰ�����');
%%
temp_brightness2=B_brightness;
temp_brightness2(find(temp_brightness2>=B_x1&temp_brightness2<=B_x2))=0;
temp_brightness_2=temp_brightness2;
temp_brightness_2(find(temp_brightness_2>0))=1;
figure
imshow(img_rgb);
hold on;
out=shadow(temp_brightness2,1);
title('�¸���˹��');
set(gcf,'color','w');
%%
temp_brightness3=B_brightness;
temp_brightness3(find(temp_brightness3>=B_x3))=0;
temp_brightness_3=temp_brightness3;
figure
imshow(img_rgb);
hold on;
out=shadow(temp_brightness3,1);
title('������');
set(gcf,'color','w');
%%
temp_brightness4=B_brightness;
temp_brightness4(find(temp_brightness4>=B_x2&temp_brightness4<=B_x3))=0;
temp_brightness_4=temp_brightness4;
temp_brightness_4(find(temp_brightness_4>0))=1;
figure
imshow(img_rgb);
hold on;
out=shadow(temp_brightness4,1);
title('Τ����');
set(gcf,'color','w');
%%
temp_brightness5=B_brightness;
temp_brightness5(find(temp_brightness5>=B_x1&temp_brightness5<=B_x3))=0;
temp_brightness_5=temp_brightness5;
temp_brightness_5(find(temp_brightness_5>0))=1;
figure
imshow(img_rgb);
hold on;
out=shadow(temp_brightness5,1);
title('�¸���˹��+Τ����');
set(gcf,'color','w');
%%
temp_brightness6=B_brightness;
temp_brightness6(find(temp_brightness6>=B_x1))=0;
temp_brightness_6=temp_brightness6;
temp_brightness_6(find(temp_brightness_6>0))=1;
figure
imshow(img_rgb);
hold on;
out=shadow(temp_brightness6,1);
title('�¸���˹��+Τ����+������');
set(gcf,'color','w');
%%
temp_brightness7=B_brightness;
temp_brightness7(find(temp_brightness7>=B_x2))=0;
temp_brightness_7=temp_brightness7;
temp_brightness_7(find(temp_brightness_7>0))=1;
figure
imshow(img_rgb);
hold on;
out=shadow(temp_brightness7,1);
title('Τ����+������');
set(gcf,'color','w');
%%  threshold processing
Gradient_value(find(Gradient_value<40))=0;%Modify the threshold to get a different gradient map
figure
imshow(uint8(Gradient_value));
title('��ֵ=40ͼ');
%%
out1=temp_brightness_2;% �¸���˹��
out2=temp_brightness_4;% Τ����
out3=temp_brightness_3;% ������
out4=temp_brightness_5;% �¸���˹��+Τ����
out5=temp_brightness_6;% �¸���˹��+Τ����+������
out6=temp_brightness_7;% Τ����+������