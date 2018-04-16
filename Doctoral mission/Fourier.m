I1=rgb2gray(imread('0.bmp'));  %读入原图像文件
I2=rgb2gray(imread('4.bmp'));  %读入原图像文件
I3=rgb2gray(imread('fish.bmp'));         %读入原图像文件
subplot(3,2,1);imshow(I1);          %显示原图像
fftI1=fft2(I1);                       %二维离散傅立叶变换

fftI1(abs(fftI1)<3000)=0;
figure,imshow(log(abs(fftI1)+eps),[]);
fftI1 = ifftshift(fftI1)
       K = ifft2(fftI1)
       figure,imshow(K,[0 255])

sfftI1=fftshift(fftI1);              %直流分量移到频谱中心
RR1=real(sfftI1);                    %取傅立叶变换的实部
II1=imag(sfftI1);                    %取傅立叶变换的虚部
A1=sqrt(RR1.^2+II1.^2);             %计算频谱幅值
A1=(A1-min(min(A1)))/(max(max(A1))-min(min(A1)))*225;%归一化
subplot(3,2,2);imshow(A1);          %显示原图像的频谱
subplot(3,2,3);imshow(I2);          %显示原图像
fftI2=fft2(I2);                       %二维离散傅立叶变换
sfftI2=fftshift(fftI2);             %直流分量移到频谱中心
RR2=real(sfftI2);                    %取傅立叶变换的实部
II2=imag(sfftI2);                   %取傅立叶变换的虚部
A2=sqrt(RR2.^2+II2.^2);             %计算频谱幅值
A2=(A2-min(min(A2)))/(max(max(A2))-min(min(A2)))*225;%归一化
subplot(3,2,4);imshow(A2);          %显示原图像的频谱
subplot(3,2,5);imshow(I3);         %显示原图像
fftI3=fft2(I3);                       %二维离散傅立叶变换
sfftI3=fftshift(fftI3);             %直流分量移到频谱中心
RR3=real(sfftI3);                   %取傅立叶变换的实部
II3=imag(sfftI3);                   %取傅立叶变换的虚部
A3=sqrt(RR3.^2+II3.^2);             %计算频谱幅值
A3=(A3-min(min(A3)))/(max(max(A3))-min(min(A3)))*225;%归一化
subplot(3,2,6);imshow(A3);          %显示原图像的频谱