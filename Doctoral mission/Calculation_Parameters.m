function out=Calculation_Parameters(input_gradient)
%% seting  parameters
threshold=[30,40,50,60];
% compared the width and length of the image to obtain the smaller
% dimension,represented by min_value. We then set the edge lengths of
% patches to 2%¡Álp, 4%¡Álp, ..., 10%¡Álp, and 12%¡Álp, respectively.
[length_img,width_img]=size(input_gradient);
min_value=min(length_img,width_img);
patch_size=[ceil(min_value*0.04),ceil(min_value*0.06),ceil(min_value*0.08)];
offset=(1:1:5);
storage_value=zeros(60,5); 
temp_variable=1;%for to save the final value 
%%
for i=1:4  % threshold
    for j=1:5  % stride
        for k=1:3 %patch size
        input_gradient(find(input_gradient<threshold(i)))=0;%Modify the threshold to get a different gradient map
        temp_input_gradient=input_gradient;
        temp_input_gradient(find(temp_input_gradient>0))=1;
        temp_input=temp_input_gradient(:,offset(j)+1:end);
        %%
        statistic_data_gradient=blkproc(temp_input,[patch_size(k) patch_size(k)],'sum2');%Select the appropriate batch size
        max_gradient_value=max(max(statistic_data_gradient));% find the max number
        same_sum_gradient_num=zeros(1,max_gradient_value);%statistics the same distance
        for i_1=1:max_gradient_value
            same_sum_gradient_num(1,i_1)=length(find(statistic_data_gradient==i_1));
        end
        %%
        out_range=range_point(same_sum_gradient_num);
        %%
        sum_value=sum(same_sum_gradient_num);
        l_p=out_range(2,1);
        r_p=out_range(2,2);
        partial_sum=sum(same_sum_gradient_num(l_p:r_p));
        ratio_value=partial_sum/sum_value;
        storage_value(temp_variable,:)=[temp_variable,threshold(i),offset(j),patch_size(k),ratio_value];
        temp_variable=temp_variable+1;% count number
        end
    end
end
temp_storage=storage_value(:,5);
temp_storage(ismember(temp_storage,1))=0;
max_ratio_value=max(max(temp_storage));% find the max number
[x,y]=find(temp_storage==max_ratio_value); % find the location of the max number
out=storage_value(x,:);