i = imread('26.bmp');
i=rgb2gray(i);
A = fspecial('gaussian');  
i = filter2(A, i) / 255;  
figure;  
imshow(i);  
imwrite(i,'lena_0.jpg');  
  
a = edge(i, 'prewitt');  
figure;  
imshow(a);  
imwrite(a,'lena_1.jpg');  
  
a = edge(i, 'sobel');  
figure;  
imshow(a);  
imwrite(a,'lena_2.jpg');  
  
a = edge(i, 'log');  
figure;  
imshow(a);  
imwrite(a,'lena_3.jpg');  
  
a = edge(i, 'canny');  
figure;  
imshow(a);  
imwrite(a,'lena_4.jpg'); 