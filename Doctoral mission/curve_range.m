function out=curve_range(input)
[m,n]=size(input);
ms=1;
ns=n;
while(ms<n&&input(1,ms)<0.05)
    ms=ms+1;
end
while(ns>0&&input(1,ns)<0.05)
    ns=ns-1;
end
out(1,:)=[ms,ns];