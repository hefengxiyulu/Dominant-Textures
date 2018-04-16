function out=range_point(input)
[m,n]=size(input);
[ma,I]=max(input);
sum_value=sum(input);
sum1=ma;
i=I;
j=I;
lable1=0;
%% you cuo wu,xu gaijin
% while(sum1<0.5*sum_value&&i>0&&j<n)
%     sum1=sum1+input(1,i)+input(1,j);
%     i=i-1;
%     j=j+1;
% end
while(sum1<0.5*sum_value&i>=0&&j<=n)
   if(i~=0&&j~=n)
    i=i-1;
    j=j+1;
   end
    if(i>0&&j<n)
        sum1=sum1+input(1,i)+input(1,j);
    end
    if(i==0&&j<n)
        sum1=sum1+input(1,j);
         j=j+1;
         lable1=1;
    end
    if(j==n&&i>0)
         sum1=sum1+input(1,i);
         i=i-1;
    end
end
% while (sum1<0.5*sum_value&&i>0)
%     sum1=sum1+input(1,i);
%     i=i-1;
% end
% while(sum1<0.5*sum_value&&j<n)
%     sum1=sum1+input(1,j);
%      j=j+1;
% end
if(i==0)  %%Coordinates start at 1 no 0
    i=1;
end
% if(lable1==1)
%     j=j-1;
% end
out(1,:)=[i,j];
while(i-1>0&&input(1,i)>input(1,i-1)&&input(1,i-1)>0)
    i=i-1;
end
while(j<n&&input(1,j)>input(1,j+1)&&input(1,j+1)>=0)
    j=j+1;
end
out(2,:)=[i,j];
ms=1;
ns=n;
while(ms<n&&input(1,ms)==0)
    ms=ms+1;
end
while(ns>0&&input(1,ns)==0)
    ns=ns-1;
end
out(3,:)=[ms,ns];


