function out=shadow_point(input)
%% 用于将梯度值处在特定区域的点映射出来
hold on;
%% 
a=input>=50&input<=100;
% a=input==1;% nature image
%%
[m n]=find(a);
for ii=1:length(m)
    x=n(ii)+[0 0 1 1];
    y=m(ii)+[0 1 1 0];
    patch(x,y,'b','edgecolor','none','facealpha',0.4);
end
%%
a=input>100&input<=150;
% a=input==2;% nature image
%%
hold on
[m n]=find(a);
for ii=1:length(m)
    x=n(ii)+[0 0 1 1];
    y=m(ii)+[0 1 1 0];
    patch(x,y,'g','edgecolor','none','facealpha',0.4);
end
%%
a=input>150&input<=200;
%a=input==3;% nature image
%%
hold on
[m n]=find(a);
for ii=1:length(m)
    x=n(ii)+[0 1 1 0];
    y=m(ii)+[0 0 1 1];
    patch(x,y,'r','edgecolor','none','facealpha',0.4);
end
%%
%%
hold on
a=input>200;
%a=input==3;% nature image
%%
[m n]=find(a);
for ii=1:length(m)
    x=n(ii)+[0 0 1 1];
    y=m(ii)+[0 1 1 0];
    patch(x,y,'y','edgecolor','none','facealpha',0.4);
end
hold off;
out=1