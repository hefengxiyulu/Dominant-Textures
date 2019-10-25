function [out_row,out_colum,out_final,out_eight_final]=Gradient_calculation(input)
[w,h]=size(input);
gradient_row=zeros(w,h);
gradient_column=zeros(w,h);
gradient_final=zeros(w,h);
%% 横、纵轴坐标分别相减，取其绝对值大的。 后一个坐标减去前一个坐标，没有考虑当前坐标与前一个坐标的差别
for i=1:w-1
    for j=1:h-1
        gradient_row(i,j)=input(i,j+1)-input(i,j);
        gradient_column(i,j)=input(i+1,j)-input(i,j);
        if(abs(gradient_row(i,j))>= abs(gradient_column(i,j)))
            gradient_final(i,j)=abs(gradient_row(i,j));
        else
            gradient_final(i,j)=abs(gradient_column(i,j));
        end
    end
end
%% 另一个计算梯度的版本，即上一个版本的改进，考虑当前点的前后，上下坐标点
before_end=zeros(w,h);                               %当前值减去后一个值
end_before=zeros(w,h);                               %后一个值减去当前值
up_down=zeros(w,h);                                  %当前行减去后一行
for col=1:h-1 
    before_end(:,col)=abs(input(:,col)-input(:,col+1));
    end_before(:,col)=input(:,col+1)-input(:,col);
end
for row=1:w-1
    up_down(row,:)=abs(input(row,:)-input(row+1,:));
end
left=zeros(w,h);
right=zeros(w,h);
up=zeros(w,h);
down=zeros(w,h);

left(:,2:h)=before_end(:,1:h-1);
right(:,1:h-1)=before_end(:,1:h-1);
up(2:w,:)=up_down(1:w-1,:);
down(1:w-1,:)=up_down(1:w-1,:);


for i=1:w
    for j=1:h
       gradient_final(i,j)=max([left(i,j),right(i,j),up(i,j),down(i,j)]);
    end
end
%% 求其8邻域坐标差，取其绝对值最大的
input_append=zeros(w+2,h+2);
input_append(2:w+1,2:h+1)=input;
out_135=abs(imfilter(input_append,[-1 0 0;0 1 0;0 0 0]));
out_90=abs(imfilter(input_append,[0 -1 0;0 1 0;0 0 0]));
out_45=abs(imfilter(input_append,[0 0 -1;0 1 0;0 0 0]));
out_180=abs(imfilter(input_append,[0 0 0;-1 1 0;0 0 0]));
out_0=abs(imfilter(input_append,[0 0 0;0 1 -1;0 0 0]));
out_225=abs(imfilter(input_append,[0 0 0;0 1 0;-1 0 0]));
out_270=abs(imfilter(input_append,[0 0 0;0 1 0;0 -1 0]));
out_315=abs(imfilter(input_append,[0 0 0;0 1 0;0 0 -1]));
max_values=zeros(w+2,h+2);
for i=1:w+2
    for j=1:h+2
        temp_gradient_value=[out_135(i,j),out_90(i,j),out_45(i,j),out_180(i,j),out_0(i,j),out_225(i,j),out_270(i,j),out_315(i,j)];
        max_values(i,j)=max(temp_gradient_value);
    end
end

%%
out_row=gradient_row;
out_colum=gradient_column;
out_final=gradient_final;
out_eight_final=max_values(2:w+1,2:h+1);