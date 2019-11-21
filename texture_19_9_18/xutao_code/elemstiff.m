function [ke] = elemstiff(e,nel,nsp,coord,connect)
%输入单元编号e，单元自由度nel，高斯点数目nsp，等分节点的坐标coord和连接矩阵connect
%输出单元刚度矩阵，是叫单元刚度矩阵吗？
ke    = zeros(nel,nel); %单刚初始化
nodes = connect(e,:);%单元相关形函数（节点）编号
xe    = coord(nodes);%相关节点的坐标
Le    = xe(nel) - xe(1);%单元长度，表示一种细度
detj  = Le/2;%雅克比行列式（一维）即为长度和标准单元长度的比值
xi = gauss_points(nsp);%选取高斯积分点【-1 1】上的
weight = gauss_weights(nsp);%高斯积分点对应的权重
for i = 1:nsp%按高斯点来进行积分计算，不同形函数之间的相互作用用列向量乘行向量来体现
  N = [ 0.5*(1 - xi(i))  0.5*(1 + xi(i))];%从标准单元映射到一般单元对于每个节点所需要的权重
  % xg = N*xe;%将高斯点映射到计算单元上去
  A = N;% 表示两个基函数在高斯点处的值，因为两个基函数，所以有两个值，因为公式相同，直接引用N值
  B = 1/Le*[-1 1];% 表示单元上两段线的斜率（导数值），即一般单元上的形函数导数值（于高斯点处）
  ke = ke + weight(i)*(-B'*B+A'*A)*detj;%计算单元刚度矩阵
end

return
end