function [out_row,out_colum,out_final,out_eight_final]=Gradient_calculation(input)
[w,h]=size(input);
gradient_row=zeros(w,h);
gradient_column=zeros(w,h);
gradient_final=zeros(w,h);
%% �ᡢ��������ֱ������ȡ�����ֵ���
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
%% ����8��������ȡ�����ֵ����
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