function out=patch_statistic(input)
%% This function is used to count the distribution of grayscale image blocks(patchs) 
% input is the gradient image
 figure
 patch1=input(60:70,95:105);
 subplot(2,2,1);
 imshow(patch1);
 title('patch1');
 hold on
 subplot(2,2,2);
 patch2=input(29:39,49:59);
 imshow(patch2);
 title('patch2');
 hold on
 subplot(2,2,3);
 patch3=input(48:58,66:76);
 imshow(patch3);
 title('patch3');
 hold on
 subplot(2,2,4);
 patch4=input(68:78,66:76);
 imshow(patch4);
 title('patch4');
 hold off
 %%
 figure
 patch5=input(10:20,12:22);
 subplot(2,2,1);
 imshow(patch5);
 title('patch5');
 hold on
 subplot(2,2,2);
 patch6=input(4:14,33:43);
 imshow(patch6);
 title('patch6');
 hold on
 subplot(2,2,3);
 patch7=input(6:16,70:80);
 imshow(patch7);
 title('patch7');
 hold on
 subplot(2,2,4);
 patch8=input(6:16,90:100);
 imshow(patch8);
 title('patch8');
 hold off
 %%
 figure
 patch9=input(60:70,3:13);
 subplot(2,2,1);
 imshow(patch9);
 title('patch9');
 hold on
 patch10=input(49:59,22:32);
 subplot(2,2,2);
 imshow(patch10);
 title('patch10');
 hold off
 %% The following code is used to count the distribution of gradient values within a block
 out_patch1=gradient_data_statistic(patch1);
 out_patch2=gradient_data_statistic(patch2);
 out_patch3=gradient_data_statistic(patch3);
 out_patch4=gradient_data_statistic(patch4);
 out_patch5=gradient_data_statistic(patch5);
 out_patch6=gradient_data_statistic(patch6);
 out_patch7=gradient_data_statistic(patch7);
 out_patch8=gradient_data_statistic(patch8);
 out_patch9=gradient_data_statistic(patch9);
 out_patch10=gradient_data_statistic(patch10);
 %% show the shadow in the original image
 figure
 imshow(input);
 rectangle('position',[95,60,10,10],'edgecolor','g');% show the rectangle on the image patch1
 rectangle('position',[49,29,10,10],'edgecolor','b');%show the patch2
 rectangle('position',[66,48,10,10],'edgecolor','y');% show the patch3
 rectangle('position',[66,68,10,10],'edgecolor','r');% show the patch4
 
 text(95,58,'\color{green}Patch1');
 text(49,27,'\color{blue}Patch2');
 text(66,46,'\color{yellow}Patch3');
 text(66,66,'\color{red}Patch4');% show the sign on the specified coordinates
 
%%
rectangle('position',[12,10,10,10],'edgecolor','r');%show patch5's rectangle
rectangle('position',[33,4,10,10],'edgecolor','b');%show patch6's rectangle
rectangle('position',[70,6,10,10],'edgecolor','g');% show the patch7's rectangle
rectangle('position',[90,6,10,10],'edgecolor','y');% patch8
rectangle('position',[3,60,10,10],'edgecolor','c');% patch9
rectangle('position',[22,49,10,10],'edgecolor','y');%patch10

text(12,8,'\color{red}Patch5');
text(33,2,'\color{blue}Patch6');
text(70,4,'\color{green}Patch7');
text(90,4,'\color{red}Patch8');% show the sign on the specified coordinates
text(3,58,'\color{green}Patch9');
text(22,47,'\color{red}Patch10');
out=1;
 