function out=shadow_add(input,value)
% I = imread('fish.bmp');
% I=rgb2gray(I);
% imshow(I);hold on;
% a=rand(10)>0.3;
hold on;
%% 
% a=input<value;% nature image
a=input>value;% structure image
%%
[m n]=find(a);
for ii=1:length(m)
%     x=n(ii)+[-1 0 0 -1];
%     y=m(ii)+[-1 -1 0 0];
x=n(ii)+[0 0 1 1];
y=m(ii)+[0 1 1 0];
    patch(x,y,'b','edgecolor','none','facealpha',0.4);
end
hold off;
% axis equal;     %axis square/����ǰ����ϵͼ������Ϊ���Ρ����ἰ���������1��1
                  %axis equal/����������Ķ���ϵ�������ֵͬ
out=1;