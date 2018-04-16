function myhist(x)
% myhist Codeby SimonLiang
% Email��idignew@126.com
% ������ʾ��״ͼ������������ֵ

h=hist(x);

hold on;

%��ʾ��״ͼ��ֵ
hBin=h.BinEdges(1:end-1)+h.BinWidth/2;
text(hBin,h.Values+max(h.Values)/25,num2cell(h.Values));

%����ٷֱ�
Hpercent=round(h.Values/sum(h.Values)*100);

%����ٷֺ�
Hpercent2=num2cell(Hpercent);
for i=1: length(Hpercent)
    Hpercent2(i)={[num2str(Hpercent(i)),'%']};
end
text(hBin,h.Values+max(h.Values)/15,Hpercent2);%��ʾ�ٷֱ�

%��ʾ����
title(['TotalCounts=',num2str(sum(h.Values))]);

hold off
end