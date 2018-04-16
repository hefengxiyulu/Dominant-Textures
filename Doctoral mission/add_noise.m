I = imread('risk.jpg');
J1 = imnoise(I,'salt & pepper',0.5); %½·ÑÎ
J2 = imnoise(I,'gaussian',0,5); %gauss
figure
imshow(J1);
hold on
imshow(J2);