clear;
% a = imread('F:\医学图像处理\测试程序\matlab(watershed)\2.bmp');
% a = ~a;
% gc = ~a;
% g = -bwdist(gc);
% im = imextendedmin(g,0.25);
% L=watershed(bwdist(a));
% em= L==0;
% % g2 = a & ~em;imshow(g2);
% g2 = imimposemin(g, im|em);
% L2 = watershed(g2);
% a(L2==0) = 0;
% figure,imshow(a);


a = imread('\2.bmp');
a = ~a;
gc = ~a;
d = bwdist(gc);
h = fspecial('gaussian',[13 13],2);
d = imfilter(d,h);
L=watershed(-d);
w= L==0;
g2 = a & ~w;
imshow(g2);