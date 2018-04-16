function out=patchs(data,level,component)
%% 1x1patch
% [W,H]=size(data_I);
component_1=blkproc(data,[1 1], 'sum2')./1;
% intensity_1=blkproc(data_I,round([0.01*W 0.01*H]), 'sum2')./(round(0.01*W)*round(0.01*H));
% fun=@sum2;
% fun='sum2';
% intensity=blkproc(data_I,[2 2], fun);
A=ones(level,1);
for ii=1:level
  A(ii,1)=length(find(component_1>(ii-1)/level&component_1<ii/level)); 
end
% figure
normalise_A=mapminmax(A', 0, 1); % 归一化
% plot(normalise_A);
%% 2x2 patch
% hold on
component_2=blkproc(data,[2 2], 'sum2')./4;
%intensity=blkproc(data_I,round([0.02*W 0.02*H]), 'sum2')./(round(0.02*W)*round(0.02*H));
B=ones(level,1);
for ii=1:level
  B(ii,1)=length(find(component_2>(ii-1)/level&component_2<ii/level)); 
end
normalise_B=mapminmax(B', 0, 1); % 归一化
% plot(normalise_B);
%% 4X4 patch
% hold on
component_4=blkproc(data,[4 4], 'sum2')./16;
% intensity_4=blkproc(data_I,round([0.04*W 0.04*H]), 'sum2')./(round(0.04*W)*round(0.04*H));
C=ones(level,1);
for ii=1:level
  C(ii,1)=length(find(component_4>(ii-1)/level&component_4<ii/level)); 
end
normalise_C=mapminmax(C', 0, 1); % 归一化
% plot(normalise_C);
%% 6x6
% hold on
component_6=blkproc(data,[6 6], 'sum2')./36;
% intensity_4=blkproc(data_I,round([0.04*W 0.04*H]), 'sum2')./(round(0.04*W)*round(0.04*H));
D=ones(level,1);
for ii=1:level
  D(ii,1)=length(find(component_6>(ii-1)/level&component_6<ii/level)); 
end
normalise_D=mapminmax(D', 0, 1); % 归一化
% plot(normalise_D);
%% 8x8
% hold on
component_8=blkproc(data,[8 8], 'sum2')./64;
% intensity_4=blkproc(data_I,round([0.04*W 0.04*H]), 'sum2')./(round(0.04*W)*round(0.04*H));
E=ones(level,1);
for ii=1:level
  E(ii,1)=length(find(component_8>(ii-1)/level&component_8<ii/level)); 
end
normalise_E=mapminmax(E', 0, 1); % 归一化
% plot(normalise_E);
%%  10x10
% hold on
component_10=blkproc(data,[10 10], 'sum2')./100;
% intensity_4=blkproc(data_I,round([0.04*W 0.04*H]), 'sum2')./(round(0.04*W)*round(0.04*H));
F=ones(level,1);
for ii=1:level
  F(ii,1)=length(find(component_10>(ii-1)/level&component_10<ii/level)); 
end
normalise_F=mapminmax(F', 0, 1); % 归一化
% plot(normalise_F);
%% 12x12
% hold on
component_12=blkproc(data,[12 12], 'sum2')./(12*12);
% intensity_4=blkproc(data_I,round([0.04*W 0.04*H]), 'sum2')./(round(0.04*W)*round(0.04*H));
G=ones(level,1);
for ii=1:level
  G(ii,1)=length(find(component_12>(ii-1)/level&component_12<ii/level)); 
end
normalise_G=mapminmax(G', 0, 1); % 归一化
% plot(normalise_G);
%% shuchu out
% out(1,:)=normalise_A;
out(1,:)=normalise_B;  %2x2   patch
out(2,:)=normalise_C;  %4x4   patch
out(3,:)=normalise_D;  %6x6   patch
out(4,:)=normalise_E;  %8x8   patch
out(5,:)=normalise_F;  %10x10 patch
out(6,:)=normalise_G;  %12x12 patch
% out=[normalise_A normalise_B normalise_C normalise_D normalise_E normalise_F normalise_G];
% title(component);
% hold off