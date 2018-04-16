function out_convo=convolution_texture(input_gradient,convo_statistic_data_gradient,point,block_size)
[M,N]=size(convo_statistic_data_gradient);
left_point=point(2,1);
right_point=point(2,2);
block=rand(M,N);
c1=0;
for i=1:M
    for j=1:N
         if(convo_statistic_data_gradient(i,j)>=left_point&&convo_statistic_data_gradient(i,j)<=right_point)
            c1=c1+1;
            convo_statistic_data_gradient(i,j)=0;
         else
                  convo_statistic_data_gradient(i,j)=1;
         end
    end
end
for i=1:M
    for j=1:N
        block(i,j)=convo_statistic_data_gradient(i,j);
    end
end
%%
[ro_1,co_1]=size(input_gradient);
temp_texture_label=ones(ro_1,co_1);
[W,H]=size(block);
for i=1:W
    for j=1:H
        if(block(i,j)==0)
            for m=1:block_size
                for n=1:block_size
                    temp_texture_label((i-1)+m,(j-1)+n)=0;
                end
            end                
         end
    end
end
out_convo=temp_texture_label(1:ro_1,1:co_1);