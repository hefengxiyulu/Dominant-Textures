vary_abs_gray_gradient=[0,0,3,5,0,0,4,0,5,6;4,3,0,0,0,5,4,0,0,0;0,0,0,5,9,0,0,0,0,5];
[m,n]=size(vary_abs_gray_gradient);
statistic_row_value=zeros(m,10);
statistic_column_value=zeros(n,10);
for i=1:m
    count_1=0;
    count_2=0;
    count_3=0;
    for j=1:n
        if(vary_abs_gray_gradient(i,j)>0&&j<n&&vary_abs_gray_gradient(i,j+1)==0)
            %&&j==0||n>1&&vary_abs_gray_gradient(i,j)>0&&vary_abs_gray_gradient(i,j-1)==0||j<n&&vary_abs_gray_gradient(i,j+1)==0
            count_1=0;
            count_2=count_2+1;
            count_3=1;
            statistic_row_value(i,count_2)=j;
        end
        if(j<n&&j>1&&vary_abs_gray_gradient(i,j+1)>0&&vary_abs_gray_gradient(i,j)==0&&count_3==1)
            count_2=count_2+1; 
            statistic_row_value(i,count_2)=j+1;
            count_3=0;
        end
    end
 end