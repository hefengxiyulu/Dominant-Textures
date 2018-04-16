img_rgb=imread('1.bmp');
%%
img_hsi=rgb2hsi(img_rgb);
data_I=img_hsi(:,:,3);
data_H=img_hsi(:,:,1);
Hue_data=data_H;
Intensity_data=data_I;
%%
img_gray=rgb2gray(img_rgb);
P=double(img_gray); 
[Px,Py]=gradient(P);
G=sqrt(Px.*Px+Py.*Py);
P=G;  
% P=mapminmax(P, 1, 10); % ��һ��
P=uint8(P);
imshow(P);
%%
hy = fspecial('sobel');
hx = hy';
Iy = imfilter(double(img_gray), hy, 'replicate');
Ix = imfilter(double(img_gray), hx, 'replicate');
gradmag = sqrt(Ix.^2 + Iy.^2);

figure('units', 'normalized', 'position', [0 0 1 1]);
subplot(1, 2, 1); imshow(img_gray,[]), title('�Ҷ���ǿͼ');
subplot(1, 2, 2); imshow(gradmag,[]), title('�ݶȷ�ֵͼ��');

%%
BW1 = edge(data_I,'canny');  % ����canny����
figure
subplot(2,2,1);
imshow(BW1);     % ��ʾ�ָ���ͼ�񣬼��ݶ�ͼ��
title('matlab canny')
hold on
subplot(2,2,2);
imshow(img_rgb);
title('original image');
hold on
subplot(2,2,3);
imshow(data_I);
title('Intensity image');
%%
out_Intensity_32=patchs(BW1,32,'Intensity');
out_Hue_32=patchs(BW1,32,'Hue');
similarity_Intensity_32=similarity(out_Intensity_32);
similarity_Hue_32=similarity(out_Hue_32);
hold on
subplot(2,2,4);
if (similarity_Intensity_32<=similarity_Hue_32)
    plot(out_Intensity_32(1,:));
    title('Intensity Histogram');
else
    plot(out_Hue_32(1,:));
    title('Hue Histogram');
end
hold off
    