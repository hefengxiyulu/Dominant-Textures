function out=gradient_data_statistic(input)
gradient_level=ones(1,256);
for ii=1:256
  gradient_level(1,ii)=length(find(input>(ii-1)&input<=ii)); 
end
figure
subplot(1,2,1);
bar(gradient_level,0.2);
% title('patch');
grid on
set(gcf,'color','w');
% set(gca,'XTickLabel',{'0.1','0.2','0.3','0.4','0.5','0.6','0.7','0.8','0.9','1'}) %设置x轴所代表大时间
hold on
subplot(1,2,2);
plot(gradient_level);
set(gcf,'color','w');
hold off
out=gradient_level;
