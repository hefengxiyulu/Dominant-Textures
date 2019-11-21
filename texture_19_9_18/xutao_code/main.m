%% һά����Ԫ����
clc;       % ��������д���
clear; %��������ռ�
close all; % �ر�����ͼ��
%% ��������
L = 1; %���嵥Ԫ���ȣ��ٶ�0Ϊ��ʼ��L��Ϊ�ұ߽�
numel = 5; %����ָ�ĵ�Ԫ��Ŀ
u_0 = 0; u_1 = 0; %�����һ��߽�����
numnod = numel + 1; %�ڵ�����ȵ�Ԫ������1���ڵ��ŵ�ͬ���κ������
nel = 2; %ÿ����Ԫ�Ľڵ���Ŀ,��ÿ����Ԫ���м����κ����������ã���Ԫ���ɶ�
nsp = 2; %��˹��ĸ�������Ϊ��Ԫ�ϵĻ���ʹ�õ��Ǹ�˹���ֹ�ʽ��
coord = linspace(0,L,numnod)'; %�ȷֽڵ�����꣨Ϊ�˷��㣬��������õȷֵķ�ʽ����ʵ�ϵ�Ԫ���ȿ��Բ�һ�£���������
connect = [1:(numnod-1); 2:numnod]';%���Ӿ��󣬱�ʾÿ����Ԫ��Χ�Ľڵ��ţ�Ҳ�����漰���κ�����ţ�һ�б�ʾһ����Ԫ��������±��1��ʼ
ebcdof = [1,numnod];   % ǿ���Ա߽��ı�ţ���������������
ebcval = [u_0,u_1]; %ǿ���Ա߽�������ȡֵ���ڵ�һ����ĵط�Ϊu0,���һ����Ϊu_1
bigk = sparse(numnod,numnod); % �նȾ���[K]����ʼ��Ϊ0��ʹ��ϡ�����洢
fext = sparse(numnod,1);      % �غ�����{f},��ʼ��Ϊ0

%%  ����ϵ������K���Ҷ���f��������װ�ܸ�
for e = 1:numel %����Ԫɨ��
  ke = elemstiff(e,nel,nsp,coord,connect);
  fe = elemforce(e,nel,nsp,coord,connect);
  sctr = connect(e,:);
  bigk(sctr,sctr) = bigk(sctr,sctr) + ke;%����λ����װ�ܸ�
  fext(sctr) = fext(sctr) + fe;
end
for i = 1:length(ebcdof)%�߽������Ĵ��������ܸٺ��غ�����
  n = ebcdof(i);%ǿ���Ա߽��ű���
  for j = 1:numnod
    if (isempty(find(ebcdof == j, 1))) % ��j���������ǹ̶���
      fext(j) = fext(j) - bigk(j,n)*ebcval(i);%���̶����������Ҷ���
    end
  end
  %��Ϊ����û�ó�֣��նȾ����ǲ�����ģ�����Ҫ��K���д�����ui��Ӧλ��ǿ�Ƹĳɱ߽�ֵ
  %��ô��Ҫ�Է�����������������Ҷ���Ҫ��ȥK�ĵ�n�г�un
  %��K�ĵ�n�е�n��Ϊ�㣬nnλ��Ϊ1���Ҷ����nλ��Ϊ��Ӧ�߽�ֵ
  %��Ȼ������Ҳ������СK����������һ����˼
  bigk(n,:) = 0.0;
  bigk(:,n) = 0.0;
  bigk(n,n) = 1.0;
  fext(n) = ebcval(i);
end
u_coeff = bigk\fext;%���ϵ������ʵ��Ҳ�Ǻ����ڶ�Ӧ���ϵ�ֵ,����׷�Ϸ�������ֱ�������ú�����
u_cal = u_coeff;
%% ��ȷ��
nsamp = 101;
xsamp = linspace(0,L,nsamp);%100�ȷ������м���100����
uexact = exactsolution(xsamp);

%% ��ͼ�����ӻ�
if (numel > 20)
  plot(coord,u_coeff,'-',xsamp,uexact,'--');
else
  plot(coord,u_coeff,'-',xsamp,uexact,'--',...
       coord,zeros(numnod,1),'mo','MarkerEdgeColor','k',...%kΪ��ɫ�߽�
      'MarkerFaceColor',[0.5 1 0.6],'MarkerSize',10);%ȦȦ��СΪ10
  %MarkerFaceColor����ǵ��ڲ��������ɫ MarkerEdgeColor����ǵ��Ե����ɫ��m�Ϻ�oԲȦ
end
h = legend('FE solution','Exact solution','location','NorthEast');%�ڷ�ͼ��
set(h,'fontsize',9);%ͼ����С
title('Comparison of FE and Exact Solutions');%����
xt = get(gca,'XTickLabel'); set(gca,'XTickLabel',xt,'fontsize',12);
%��ȡͼ��ĺ�����tick�����û�ȡ��tick������ͼ��ĺ������ʶ
yt = get(gca,'XTickLabel'); set(gca,'XTickLabel',yt,'fontsize',12);
xlabel('$x$','Interpreter','latex','fontsize',16)%latex�������µĺ�������������ʾ
ylabel('$u^h , u$','Interpreter','latex','fontsize',16);

%% ����������������ֻ��ʹ�ýڵ㴦��ֵ�����ƣ���û�м��㵥Ԫ������Ϊ׼ȷ�����
%�������ף�������
u_ex = exactsolution(coord);
error_L1 = sum(abs(u_cal - u_ex))/(numnod-1) %��ÿ���ڵ��ƽ�����
error_L2 = sqrt(sum((u_cal - u_ex).^2)/(numnod-1))
error_Linf = max(abs(u_cal - u_ex))




















