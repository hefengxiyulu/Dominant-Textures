function block_texture=gradient_texture(input_gradient,block_gradient_sum,point,block_size)
[M,N]=size(block_gradient_sum);
left_point=point(2,1);
right_point=point(2,2);
block=rand(M,N);
c1=0;
%% The value in the interval, set to 0, on the contrary, set to 1
for i=1:M
    for j=1:N
         if(block_gradient_sum(i,j)>=left_point&&block_gradient_sum(i,j)<=right_point)
            c1=c1+1;
            block_gradient_sum(i,j)=0;
         else
              block_gradient_sum(i,j)=1;
        end
    end
end
for i=1:M
    for j=1:N
        block(i,j)=block_gradient_sum(i,j);
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
                    temp_texture_label(block_size*(i-1)+m,block_size*(j-1)+n)=0;
                end
            end                
         end
    end
end
block_texture=temp_texture_label(1:ro_1,1:co_1);