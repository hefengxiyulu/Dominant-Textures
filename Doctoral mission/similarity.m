function out=similarity(input)
[m,n]=size(input);
c=0;
value=0;
for i=1:m-1
for j=i+1:m
    value=chi2(input(i,:),input(j,:));
    c=c+value;
end
end
out=c;