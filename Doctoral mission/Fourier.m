I1=rgb2gray(imread('0.bmp'));  %����ԭͼ���ļ�
I2=rgb2gray(imread('4.bmp'));  %����ԭͼ���ļ�
I3=rgb2gray(imread('fish.bmp'));         %����ԭͼ���ļ�
subplot(3,2,1);imshow(I1);          %��ʾԭͼ��
fftI1=fft2(I1);                       %��ά��ɢ����Ҷ�任

fftI1(abs(fftI1)<3000)=0;
figure,imshow(log(abs(fftI1)+eps),[]);
fftI1 = ifftshift(fftI1)
       K = ifft2(fftI1)
       figure,imshow(K,[0 255])

sfftI1=fftshift(fftI1);              %ֱ�������Ƶ�Ƶ������
RR1=real(sfftI1);                    %ȡ����Ҷ�任��ʵ��
II1=imag(sfftI1);                    %ȡ����Ҷ�任���鲿
A1=sqrt(RR1.^2+II1.^2);             %����Ƶ�׷�ֵ
A1=(A1-min(min(A1)))/(max(max(A1))-min(min(A1)))*225;%��һ��
subplot(3,2,2);imshow(A1);          %��ʾԭͼ���Ƶ��
subplot(3,2,3);imshow(I2);          %��ʾԭͼ��
fftI2=fft2(I2);                       %��ά��ɢ����Ҷ�任
sfftI2=fftshift(fftI2);             %ֱ�������Ƶ�Ƶ������
RR2=real(sfftI2);                    %ȡ����Ҷ�任��ʵ��
II2=imag(sfftI2);                   %ȡ����Ҷ�任���鲿
A2=sqrt(RR2.^2+II2.^2);             %����Ƶ�׷�ֵ
A2=(A2-min(min(A2)))/(max(max(A2))-min(min(A2)))*225;%��һ��
subplot(3,2,4);imshow(A2);          %��ʾԭͼ���Ƶ��
subplot(3,2,5);imshow(I3);         %��ʾԭͼ��
fftI3=fft2(I3);                       %��ά��ɢ����Ҷ�任
sfftI3=fftshift(fftI3);             %ֱ�������Ƶ�Ƶ������
RR3=real(sfftI3);                   %ȡ����Ҷ�任��ʵ��
II3=imag(sfftI3);                   %ȡ����Ҷ�任���鲿
A3=sqrt(RR3.^2+II3.^2);             %����Ƶ�׷�ֵ
A3=(A3-min(min(A3)))/(max(max(A3))-min(min(A3)))*225;%��һ��
subplot(3,2,6);imshow(A3);          %��ʾԭͼ���Ƶ��