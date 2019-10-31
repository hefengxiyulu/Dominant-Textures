function out=shadow_multi(input)
hold on;
%% 
a=input==1;% nature image
%%
[m n]=find(a);
for ii=1:length(m)
    x=n(ii)+[0 0 1 1];
    y=m(ii)+[0 1 1 0];
    patch(x,y,'b','edgecolor','none','facealpha',0.4);
end
%%
a=input==2;% nature image
%%
hold on;
[m n]=find(a);
for ii=1:length(m)
    x=n(ii)+[0 0 1 1];
    y=m(ii)+[0 1 1 0];
    patch(x,y,'g','edgecolor','none','facealpha',0.4);
end
%%
a=input==3;% nature image
%%
hold on;
[m n]=find(a);
for ii=1:length(m)
    x=n(ii)+[0 0 1 1];
    y=m(ii)+[0 1 1 0];
    patch(x,y,'r','edgecolor','none','facealpha',0.4);
end
hold off;
out=1