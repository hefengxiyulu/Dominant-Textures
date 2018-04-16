clc;
clear;
[filename pathname filter] = uigetfile('*.jpg;*.png;*.tif;*.img;*.bmp;*.gif;','图像文件');
if filter == 0
return
end
x= fullfile(pathname,filename);
A= imread(x);
imshow(A);
A=double(A);
[M,N]=size(A);
temp=zeros(1,256);

%对图像的灰度值在[0,255]上做统计
for m=1:M;
for n=1:N;
if A(m,n)==0;
i=1;
else
i=A(m,n);
end
temp(i)=temp(i)+1;
end
end
temp=temp./(M*N);
%由熵的定义做计算
result=0;
for i=1:length(temp)
if temp(i)==0;
result=result;
else
result=result-temp(i)*log2(temp(i));
end
end
result

%计算联合熵
%随机生成图像
A=floor(rand(8,8).*255);
B=floor(rand(8,8).*255);
[M,N]=size(A);
temp=zeros(256,256);
%对图像的灰度值成对地做统计
for m=1:M;
for n=1:N;
if A(m,n)==0;
i=1;
else
i=A(m,n);
end
if B(m,n)==0;
j=1;
else
j=B(m,n);
end
temp(i,j)=temp(i,j)+1;
end
end
temp=temp./(M*N);
%由熵的定义做计算
result=0;
for i=1:size(temp,1)
for j=1:size(temp,2)
if temp(i,j)==0;
result=result;
else
result=result-temp(i,j)*log2(temp(i,j));
end
end
end
result