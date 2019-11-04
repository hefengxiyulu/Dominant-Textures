%% 画椭圆
clear all
close all
%% ellipse1函数根据椭圆中心坐标、长半轴、偏心率和方向角画椭圆。
ecc = axes2ecc(10,5);  % 根据长半轴和短半轴计算椭圆偏心率
[elat,elon] = ellipse1(10,15,[10 ecc],90);
plot(elat,elon)
axis([0 30 0 30]);
line([0,10],[25,25],'linestyle','--');
line([0,10],[5,5],'linestyle','--');
text(-1,25,cellstr('b1'));
text(-1,5,cellstr('a1'));
text(6,15,cellstr('c(y)'));
text(13,15,cellstr('r(y)'));
set(gca,'Xtick',[],'Ytick',[]);
text(29,-1,cellstr('x'))
text(-1,29,cellstr('x'))
%%
figure
ecc = axes2ecc(10,5);  % 根据长半轴和短半轴计算椭圆偏心率
[elat,elon] = ellipse1(10,15,[10 ecc],90);
plot(elat,elon)
axis([0 30 0 30]);
line([5,5],[0,15],'linestyle','--');
line([15,15],[0,15],'linestyle','--');
text(5,-1,cellstr('c1'));
text(15,-1,cellstr('d1'));
text(9,23,cellstr('m(x)'));
text(9,7,cellstr('g(x)'));
text(29,-1,cellstr('x'))
text(-1,29,cellstr('x'))
set(gca,'Xtick',[],'Ytick',[]);
%%
im1 = rand(50,40,3);
im2 = rand(50,50,3);
imwrite(im1,'myMultipageFile.tif')
imwrite(im2,'myMultipageFile.tif','WriteMode','append')


