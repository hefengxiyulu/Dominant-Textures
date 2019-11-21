function [fe] = elemforce(e,nel,nsp,coord,connect)
%输入单元编号3，单元自由度nel，高斯点数目nsp，等分坐标点coord和连接矩阵connect
%输入单元载荷向量
fe = zeros(nel,1);%初始化单元载荷向量为0
nodes = connect(e,:);%单元相关节点的编号
xe = coord(nodes); % 单元相关节点坐标
Le  = xe(nel) - xe(1);%单元长度
detj = Le/2;%雅克比行列式
xi = gauss_points(nsp);%高斯点
weight = gauss_weights(nsp);%高斯点对应的高斯权重
for i = 1:nsp
  N = [ 0.5*(1 - xi(i))  0.5*(1 + xi(i)) ];%从标准单元映射到一般单元对于每个节点所需要的权重
  xg = N*xe;%计算高斯点在一般单元上对应的位置，即将高斯点在标准单元映射会一般单元
  bx = fun(xg);%计算相应点的函数值
  fe = fe + weight(i)*bx*N'*detj;%计算单元载荷
end

return
end