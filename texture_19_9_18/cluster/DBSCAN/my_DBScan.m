function [out]=my_DBScan(input_matrix,epsilon,MinPts)
%% д��2019.11.6 ʹ��DBSCAN����ȿ��ͳ��ɢ��ͼ���о���
% input_matrix������ɢ����������
% epsilon����-����ȷ����������򣬼�����o�Ħ�-��������oΪ���ģ��Ԧ�Ϊ�뾶�Ŀռ䡣
% MinPts��������ܶȣ����������ڵĶ���������������������ܶȷ�ֵ�ɲ���Minptsȷ�����û�ָ������
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