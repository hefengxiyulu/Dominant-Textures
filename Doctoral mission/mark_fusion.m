%% This part of the code is mainly used to display the overlap of multiple dominant texture regions
function out=mark_fusion(img,input_1,input_2,input_3,input_4,input_5,input_6)
% [row_1,col_1]=size(input);
sum_input=input_1+input_2+input_3+input_4+input_5+input_6;
temp_sum_input=sum_input;
sum_input(find(sum_input<3))=0;%% >=3 regions fusion
figure
imshow(img);
hold on
out=shadow(sum_input,1);
title('gray-image-teture');
hold off
%
temp_sum_input(find(temp_sum_input>=3))=0;%The opposite regions of the above part
figure
imshow(img);
hold on
out=shadow(temp_sum_input,1);
title('gray-image-teture');
hold off
out=1;