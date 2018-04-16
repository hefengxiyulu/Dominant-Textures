function block=texture(data_I,intensity,point)
[M,N]=size(intensity);
left_point=point(2,1);
right_point=point(2,2);
block=rand(M,N);
c1=0;
for i=1:M
    for j=1:N
         if(intensity(i,j)>left_point/32&&intensity(i,j)<right_point/32)
%           if(intensity(i,j)>7/32&intensity(i,j)<15/32)
%             if(intensity(i,j)>13/32&intensity(i,j)<23/32)
%               if(intensity(i,j)>7/32&intensity(i,j)<13/32)
            c1=c1+1;
            intensity(i,j)=0;
        end
    end
end
for i=1:M
    for j=1:N
        block(i,j)=intensity(i,j);
    end
end