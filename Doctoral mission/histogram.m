I=imread('fish.bmp');
I= rgb2gray(I);
figure;
imshow(I);
title('1yuantu');
figure;
imhist(I);
title('2zhifangtu');
[m,n]=size(I);%����ͼ���С
[counts,x]=imhist(I,30);%������29��С����ĻҶ�ֱ��ͼ���ѻҶ�ֵ256����ƽ����Ϊ29�����䣩 
                        %countsΪ��Ӧֱ��ͼ��ֵ��xΪλ��
counts=counts/m/n;%�����һ���Ҷ�ֱ��ͼ�������ֵ
figure;
stem(x,counts);%���ƹ�һ��ֱ��ͼ
title('3guiyihuazhifangtu');