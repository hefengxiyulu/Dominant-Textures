%%
% clc;clear;
% %% ÇúÏßÄâºÏ
% 
% x=[0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0];
% y=[0, 4, 5, 14, 15, 14.5, 14, 12, 10, 5, 4];
% scatter(x,y,'filled');
% len_x = length(x);
% 
% max_x = max(x);
% min_x = min(x);
% 
% num = 100;
% delta = (max_x-min_x)/num;
% x_f =[];
% f =[];
% max_delta = (max_x-min_x)*3/10;
% for i=0:num
%     x_val = min_x + i*delta;
%     x_f = [x_f,x_val];
%     A = zeros(2,2);
%     B = [];
%     for j=1:len_x
%         s = abs(x(j)-x_val)/max_delta;
%         if s<=0.5
%             w = 2/3-4*s^2+4*s^3;
%         elseif s<=1
%             w = 4/3-4*s+4*s^2-4*s^3/3;
%         else
%             w = 0;
%         end
%         A = A + w*[1;x(j)]*[1,x(j)];
%         B = [B,w*[1;x(j)]];
%     end
%     f =[f,[1,x_val]*inv(A)*B*y'];
% end
% hold on
% plot(x_f,f,'r');
%%
% two-DIMENSIONAL MLS APPROXIMATION
% by Jin Jia
clc
clear all

% SET UP NODAL COORDINATES
[xI,yI] = meshgrid(-2: 0.5 : 2);
nnodes = length(xI)*length(yI);
% SET UP COORDINATES OF EVALUATION POINTS
[x,y] =meshgrid (-2 : 0.1: 2);
npoints = length(x)*length(y);
scale = 3;
% DETERMINE RADIUS OF SUPPORT OF EVERY NODE
dmI = scale *0.5* ones(1, nnodes);
% Evaluate MLS shape function at all evaluation points x
[PHI, DPHIx, DPHIy] = MLS2DShape(3, nnodes, xI,yI, npoints, x,y, dmI, 'GAUSS', 3.0 );
% Curve fitting. y = peaks(x,y)
ZI  =xI.*exp(-xI.^2- yI.^2);    % Nodal function values
z  =x.*exp(-x.^2- y.^2);% Exact solution
Zpoints=zeros(1,npoints);
for i=1:npoints
    Zpoints(1,i)=z(i);
end
Znodes=zeros(1,nnodes);
for i=1:nnodes
    Znodes(1,i)=ZI(i);
end                        %conveerse two-dimension data to one-dimension data
zh = PHI *Znodes';  % Approximation function
err = norm(Zpoints' - zh) / norm(Zpoints) * 100;% Relative error norm in approximation function
%converse one-dimension data to two-dimension data
Zponintsh=reshape(zh,length(y),length(x));
%
[dZx,dZy]= gradient(z,0.1,0.1);
ddzx=reshape(dZx,1,npoints);
ddzy=reshape(dZy,1,npoints);
dZhx  = DPHIx * Znodes';  % First order derivative of approximation function
errd = norm(ddzx' - dZhx) / norm(ddzx) * 100;  % Relative error norm in the first order derivative
dZponintshx=reshape(dZhx,length(y),length(x));
dZhy  = DPHIy * Znodes';  % Second order derivative of approximation function
errdd = norm(ddzy' - dZhy) / norm(ddzy) * 100;  % Relative error norm in second order derivative
dZponintshy=reshape(dZhy,length(y),length(x));
