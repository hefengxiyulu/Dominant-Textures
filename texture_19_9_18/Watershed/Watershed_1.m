%%
clear all
close all
addpath(genpath(pwd));
%% input the picture
[FileName, FilePath]=uigetfile('*.jpg;*.png;*.tif;*.img;*.bmp;*.gif;','ÇëÑ¡ÔñÍ¼ÏñÊý¾Ý');
str=[FilePath FileName];
img_rgb=imread(str);
%% load shadow matrix
shadow_matrix_LR_UD=cell2mat(struct2cell(load('shadow_matrix_LR_UD')));
shadow_matrix_LR_UD=logical(shadow_matrix_LR_UD);
figure
imshow(shadow_matrix_LR_UD);
%%
center1 = -40;
center2 = -center1;
dist = sqrt(2*(2*center1)^2);
radius = dist/2 * 1.4;
lims = [floor(center1-1.2*radius) ceil(center2+1.2*radius)];
[x,y] = meshgrid(lims(1):lims(2));
bw1 = sqrt((x-center1).^2 + (y-center1).^2) <= radius;
bw2 = sqrt((x-center2).^2 + (y-center2).^2) <= radius;
bw = bw1 | bw2;
bw=shadow_matrix_LR_UD;
figure
imshow(bw)
title('Binary Image with Overlapping Objects')
%%
D = bwdist(~bw);
imshow(D,[])
title('Distance Transform of Binary Image')
%%
D = -D;
imshow(D,[])
title('Complement of Distance Transform')
%%
L = watershed(D);
L(~bw) = 0;
%%
rgb = label2rgb(L,'jet',[.5 .5 .5]);
imshow(rgb)
title('Watershed Transform')