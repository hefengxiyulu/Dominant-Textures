function y=chi2(A,B)
[M,N]=size(A');
for ii=1:M
    value(ii)=(A(ii)-B(ii))^2/(A(ii)+B(ii));
end
y=1/2*nansum(value);