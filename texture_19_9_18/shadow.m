function out=shadow(input,value)
hold on;
%% 
a=input<value;% nature image
% a=input>value;% structure image
%%
[m n]=find(a);
for ii=1:length(m)
    x=n(ii)+[0 0 1 1];
    y=m(ii)+[0 1 1 0];
    patch(x,y,'b','edgecolor','none','facealpha',0.4);
end
hold off;
% axis equal;     %axis square/����ǰ����ϵͼ������Ϊ���Ρ����ἰ���������1��1
%axis equal/����������Ķ���ϵ�������ֵͬ
out=1;