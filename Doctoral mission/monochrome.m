[FileName, FilePath]=uigetfile('*.jpg;*.png;*.tif;*.img;*.bmp;*.gif;','请选择图像数据');
str=[FilePath FileName];
Image=imread(str);
% 以对话框的形式选择打开一幅图像
Gray=rgb2gray(Image);
R=Image(:,:,1); G=Image(:,:,2); B=Image(:,:,3);
diff_R=0; diff_G=0; diff_B=0;  % 设置红、绿、蓝三种颜色提取阈值（越大越严格）

Image_R=Image;
RP_R=Image(:,:,1); RP_G=Image(:,:,2); RP_B=Image(:,:,3);
XYR=~((R-G)>diff_R&(R-B)>diff_R);  % 提取红色条件是R分量与G、B分量差值大于设定
Mask=Gray(XYR);  % 灰照片掩膜
RP_R(XYR)=Mask; RP_G(XYR)=Mask; RP_B(XYR)=Mask;  % 使得非红色区域变为灰色
Image_R(:,:,1)=RP_R; Image_R(:,:,2)=RP_G; Image_R(:,:,3)=RP_B;

Image_G=Image;
GP_R=Image(:,:,1); GP_G=Image(:,:,2); GP_B=Image(:,:,3);
XYG=~((G-R)>diff_G&(G-B)>diff_G);  % 提取绿色条件是G分量与R、B分量差值大于设定
Mask=Gray(XYG);  % 灰照片掩膜
GP_R(XYG)=Mask; GP_G(XYG)=Mask; GP_B(XYG)=Mask;  % 使得非绿色区域变为灰色
Image_G(:,:,1)=GP_R; Image_G(:,:,2)=GP_G; Image_G(:,:,3)=GP_B;

Image_B=Image;
BP_R=Image(:,:,1);BP_G=Image(:,:,2);BP_B=Image(:,:,3);
XYB=~((B-R)>diff_B&(B-G)>diff_B);  % 提取绿色条件是G分量与R、B分量差值大于设定
Mask_B=Gray(XYB);  % 灰照片掩膜
BP_R(XYB)=Mask_B; BP_G(XYB)=Mask_B; BP_B(XYB)=Mask_B;  % 使得非蓝色区域变为灰色
Image_B(:,:,1)=BP_R; Image_B(:,:,2)=BP_G; Image_B(:,:,3)=BP_B;

subplot(2,2,1),imshow(Image); title('Image');
subplot(2,2,2),imshow(Image_R); title('Red Pass');
subplot(2,2,3),imshow(Image_G); title('Green Pass');
subplot(2,2,4),imshow(Image_B); title('Blue Pass');
% 显示原图与R/G/B三色提取结果对比图并显示标签

imwrite(Image_R,'Image_R.jpg','jpeg');
imwrite(Image_G,'Image_G.jpg','jpeg');
imwrite(Image_B,'Image_B.jpg','jpeg');
% 将R/G/B三色提取结果写成jpg文件保存到当前目录