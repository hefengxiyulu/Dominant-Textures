%%
% 2019.11.6,�ò�ͬ����ɫ��ǲ�ͬ������
%%
function out=shadow_SB_pro(input,k)
Colors=hsv(k);
for i=1:k
    hold on
    Color = Colors(i,:);
    a=input==i;
    [m n]=find(a);
    for ii=1:length(m)
        x=n(ii)+[0 0 1 1];
        y=m(ii)+[0 1 1 0];
        patch(x,y,Color,'edgecolor','none','facealpha',0.4);
    end
end
%%
hold on;
%%
a=input==0;% nature image
[m n]=find(a);
for ii=1:length(m)
    x=n(ii)+[0 0 1 1];
    y=m(ii)+[0 1 1 0];
    patch(x,y,'k','edgecolor','none','facealpha',0.4);
end
%%
hold off;
out=1