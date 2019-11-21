%% 一维有限元程序
clc;       % 清空命令行窗口
clear; %清除工作空间
close all; % 关闭所有图像
%% 参数设置
L = 1; %定义单元长度，假定0为初始，L即为右边界
numel = 5; %定义分割的单元数目
u_0 = 0; u_1 = 0; %定义第一类边界条件
numnod = numel + 1; %节点个数比单元个数多1，节点编号等同于形函数编号
nel = 2; %每个单元的节点数目,即每个单元上有几个形函数参与作用，单元自由度
nsp = 2; %高斯点的个数（因为单元上的积分使用的是高斯积分公式）
coord = linspace(0,L,numnod)'; %等分节点的坐标（为了方便，我这里采用等分的方式，事实上单元长度可以不一致），列向量
connect = [1:(numnod-1); 2:numnod]';%连接矩阵，表示每个单元周围的节点编号，也就是涉及的形函数编号，一行表示一个单元的情况，下标从1开始
ebcdof = [1,numnod];   % 强制性边界点的编号，本例子中是两端
ebcval = [u_0,u_1]; %强制性边界条件的取值，在第一个点的地方为u0,最后一个点为u_1
bigk = sparse(numnod,numnod); % 刚度矩阵[K]，初始化为0，使用稀疏矩阵存储
fext = sparse(numnod,1);      % 载荷向量{f},初始化为0

%%  计算系数矩阵K和右端项f，单刚组装总刚
for e = 1:numel %按单元扫描
  ke = elemstiff(e,nel,nsp,coord,connect);
  fe = elemforce(e,nel,nsp,coord,connect);
  sctr = connect(e,:);
  bigk(sctr,sctr) = bigk(sctr,sctr) + ke;%按照位置组装总刚
  fext(sctr) = fext(sctr) + fe;
end
for i = 1:length(ebcdof)%边界条件的处理，处理总纲和载荷向量
  n = ebcdof(i);%强制性边界编号遍历
  for j = 1:numnod
    if (isempty(find(ebcdof == j, 1))) % 第j个点若不是固定点
      fext(j) = fext(j) - bigk(j,n)*ebcval(i);%按固定点来处理右端项
    end
  end
  %因为条件没用充分，刚度矩阵是不可逆的，我们要对K进行处理，即ui对应位置强制改成边界值
  %那么需要对方程组进行修正，即右端项要减去K的第n列乘un
  %置K的第n行第n列为零，nn位置为1，右端项第n位子为对应边界值
  %当然，我们也可以缩小K矩阵来处理，一个意思
  bigk(n,:) = 0.0;
  bigk(:,n) = 0.0;
  bigk(n,n) = 1.0;
  fext(n) = ebcval(i);
end
u_coeff = bigk\fext;%求出系数，事实上也是函数在对应点上的值,可用追赶法求，我这直接用内置函数了
u_cal = u_coeff;
%% 求精确解
nsamp = 101;
xsamp = linspace(0,L,nsamp);%100等分区间中间有100个数
uexact = exactsolution(xsamp);

%% 绘图，可视化
if (numel > 20)
  plot(coord,u_coeff,'-',xsamp,uexact,'--');
else
  plot(coord,u_coeff,'-',xsamp,uexact,'--',...
       coord,zeros(numnod,1),'mo','MarkerEdgeColor','k',...%k为黑色边界
      'MarkerFaceColor',[0.5 1 0.6],'MarkerSize',10);%圈圈大小为10
  %MarkerFaceColor：标记点内部的填充颜色 MarkerEdgeColor：标记点边缘的颜色，m紫红o圆圈
end
h = legend('FE solution','Exact solution','location','NorthEast');%摆放图例
set(h,'fontsize',9);%图例大小
title('Comparison of FE and Exact Solutions');%标题
xt = get(gca,'XTickLabel'); set(gca,'XTickLabel',xt,'fontsize',12);
%获取图像的横坐标tick，利用获取的tick，设置图像的横坐标标识
yt = get(gca,'XTickLabel'); set(gca,'XTickLabel',yt,'fontsize',12);
xlabel('$x$','Interpreter','latex','fontsize',16)%latex解释器下的横纵坐标名称显示
ylabel('$u^h , u$','Interpreter','latex','fontsize',16);

%% 计算误差，我这里的误差只是使用节点处的值来估计，并没有计算单元积分作为准确的误差
%算收敛阶，大差不差了
u_ex = exactsolution(coord);
error_L1 = sum(abs(u_cal - u_ex))/(numnod-1) %算每个节点的平均误差
error_L2 = sqrt(sum((u_cal - u_ex).^2)/(numnod-1))
error_Linf = max(abs(u_cal - u_ex))




















