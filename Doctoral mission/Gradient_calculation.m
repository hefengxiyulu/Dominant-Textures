function [out_row,out_colum,out_final]=Gradient_calculation(input)
[w,h]=size(input);
gradient_row=zeros(w,h);
gradient_column=zeros(w,h);
gradient_final=zeros(w,h);
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
out_row=gradient_row;
out_colum=gradient_column;
out_final=gradient_final;