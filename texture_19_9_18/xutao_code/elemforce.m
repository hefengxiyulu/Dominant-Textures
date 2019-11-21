function [fe] = elemforce(e,nel,nsp,coord,connect)
%���뵥Ԫ���3����Ԫ���ɶ�nel����˹����Ŀnsp���ȷ������coord�����Ӿ���connect
%���뵥Ԫ�غ�����
fe = zeros(nel,1);%��ʼ����Ԫ�غ�����Ϊ0
nodes = connect(e,:);%��Ԫ��ؽڵ�ı��
xe = coord(nodes); % ��Ԫ��ؽڵ�����
Le  = xe(nel) - xe(1);%��Ԫ����
detj = Le/2;%�ſ˱�����ʽ
xi = gauss_points(nsp);%��˹��
weight = gauss_weights(nsp);%��˹���Ӧ�ĸ�˹Ȩ��
for i = 1:nsp
  N = [ 0.5*(1 - xi(i))  0.5*(1 + xi(i)) ];%�ӱ�׼��Ԫӳ�䵽һ�㵥Ԫ����ÿ���ڵ�����Ҫ��Ȩ��
  xg = N*xe;%�����˹����һ�㵥Ԫ�϶�Ӧ��λ�ã�������˹���ڱ�׼��Ԫӳ���һ�㵥Ԫ
  bx = fun(xg);%������Ӧ��ĺ���ֵ
  fe = fe + weight(i)*bx*N'*detj;%���㵥Ԫ�غ�
end

return
end