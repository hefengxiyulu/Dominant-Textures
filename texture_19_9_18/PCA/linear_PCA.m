function linear_PCA 

%% PARAMETERS

N = 500;			% number of data points
R = [-.9 .4; .1 .2];	% covariance matrix

%% PROGRAM
tic

X = randn(N,2)*R;	% correlated two-dimensional data

[E,v,Xp] = km_pca(X,1);		% obtain eigenvector matrix E, eigenvalues v and principal components Xp

toc
%% OUTPUT
Y = X*E(:,2);
figure; hold on
plot(X(:,1),X(:,2),'.')
plot(E(1,1)*Xp,E(2,1)*Xp,'.r')
plot(E(1,2)*Y,E(2,2)*Y,'.b')
plot([0 E(1,1)],[0 E(2,1)],'g','LineWidth',4)
plot([0 E(1,2)],[0 E(2,2)],'k','LineWidth',4)
axis equal
legend('data','first principal components','second principal components','first principal direction','second principal direction')
title('linear PCA demo')

function [E,v,Xp] = km_pca(X,m)
N = size(X,1);
[E,V] = eig(X'*X/N);

v = diag(V);
[v,ind] = sort(v,'descend');
E = E(:,ind);

Xp = X*E(:,1:m);