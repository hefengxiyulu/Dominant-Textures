function [out]=my_DBScan(input_matrix,epsilon,MinPts)
%% 写于2019.11.6 使用DBSCAN对剃度块的统计散点图进行聚类
% input_matrix：输入散点的坐标矩阵
% epsilon：ε-领域：确定对象的领域，即对象o的ε-领域是以o为中心，以ε为半径的空间。
% MinPts：领域的密度：可用领域内的对象数度量。稠密区域的密度阀值由参数Minpts确定（用户指定）。
%%
X=input_matrix;
%%KNN k distance graph, to determine the epsilon
A=X;
numData=size(A,1);
Kdist=zeros(numData,1);
[IDX,Dist]=knnsearch(A(2:numData,:),A(1,:));
Kdist(1)=Dist;
for i=2:size(A,1)
    [IDX,Dist] = knnsearch(A([1:i-1,i+1:numData],:),A(i,:));
    Kdist(i)=Dist;
end
[sortKdist,sortKdistIdx]=sort(Kdist,'descend');
distX=[1:numData]';
plot(distX,sortKdist,'r+-','LineWidth',2);
set(gcf,'position',[1000 340 350 350]);
title('Distance distribution diagram');
grid on;
%% Run DBSCAN Clustering Algorithm
% epsilon= 3 ;
% MinPts=  2  ;
IDX1=DBSCAN(X,epsilon,MinPts);
%% Plot Results
figure;
PlotClusterinResult(X, IDX1);
title(['DBSCAN Clustering (\epsilon = ' num2str(epsilon) ', MinPts = ' num2str(MinPts) ')']);
set(gcf,'position',[30 -10 500 500]); 
out =IDX1;
end