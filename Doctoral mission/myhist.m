function myhist(x)
% myhist Codeby SimonLiang
% Email：idignew@126.com
% 用于显示柱状图比例及具体数值

h=hist(x);

hold on;

%显示柱状图数值
hBin=h.BinEdges(1:end-1)+h.BinWidth/2;
text(hBin,h.Values+max(h.Values)/25,num2cell(h.Values));

%计算百分比
Hpercent=round(h.Values/sum(h.Values)*100);

%加入百分号
Hpercent2=num2cell(Hpercent);
for i=1: length(Hpercent)
    Hpercent2(i)={[num2str(Hpercent(i)),'%']};
end
text(hBin,h.Values+max(h.Values)/15,Hpercent2);%显示百分比

%显示标题
title(['TotalCounts=',num2str(sum(h.Values))]);

hold off
end