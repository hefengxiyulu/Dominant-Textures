function [out1,out2]=convolution_compute(input,patch_size)
convo_kernel=ones(patch_size,patch_size);
input=double(input);
convo_statistic_data_gradient=conv2(input,convo_kernel,'valid');
convo_max_gradient_value=max(max(convo_statistic_data_gradient));% find the max number
convo_same_sum_gradient_num=zeros(1,convo_max_gradient_value);%statistics the same distance
for i_1=1:convo_max_gradient_value
convo_same_sum_gradient_num(1,i_1)=length(find(convo_statistic_data_gradient==i_1));
end
out1=convo_same_sum_gradient_num;
out2=convo_statistic_data_gradient;