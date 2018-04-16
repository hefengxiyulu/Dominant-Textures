clc;
clear;
[filename pathname filter] = uigetfile('*.jpg;*.png;*.tif;*.img;*.bmp;*.gif;','Í¼ÏñÎÄ¼þ');
if filter == 0
return
end
x = fullfile(pathname,filename);
I=imread(x);
imshow(I);
[ix,iy]=size(I);
P1=imhist(I)/(ix*iy);
temp=double(I);
temp=[temp,temp(:,1)];
CoefficientMat=zeros(256,256);
for x=1:ix
  for y=1:iy
i=temp(x,y); j=temp(x,y+1);
CoefficientMat(i+1,j+1)
CoefficientMat(i+1,j+1)+1;
   end
end
%P2=CoefficientMat./(ix*iy);
P2=CoefficientMat./(ix*iy);
H1=0;H2=0;
for i=1:256
if P1(i)~=0
H1=H1-P1(i)*log2(P1(i));
end
for j=1:256
if  P2(i,j)~=0
H2=H2-P2(i,j)*log2(P2(i,j));
end
end
end
H2=H2/2;