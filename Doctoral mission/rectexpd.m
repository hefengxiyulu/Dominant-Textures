% 2014-8-25  rectexpd.m
% �����źŴ�---�źŷֽ���ϳ�
% T1�������ź�����Ϊ��-T1/2,T1/2)
% T0: �����źŴ�����
% m:  ����Ҷ����չ�������

T1=2;T0=4;m=9;
t1=-T1/2:0.01:T1/2;
t2=T1/2:0.01:(T0-T1/2);
t=[(t1-T0)';(t2-T0)';t1';t2';(t1+T0)'];
n1=length(t1);
n2=length(t2);  % �������ھ����źź������ڣ��������
f=[ones(n1,1);zeros(n2,1);ones(n1,1);zeros(n2,1);ones(n1,1)];
                % �������ھ����źŴ�
y=zeros(m+1,length(t));
y(m+1,:)=f';
figure(1);
h=plot(t,y(m+1,:)); % �������ھ����źŴ�
set(h,'LineWidth',3*get(h,'LineWidth')); % ����ͼ�ε��߿�Ϊԭ����3��
axis([-(T0+T1/2)-0.5,(T0+T1/2)+0.5,0,1.2]);
set(gca,'XTick',-T0-1:1:T0+1);
title('�����źŴ�');
grid;

figure(2);
a=T1/T0;
pause;    % ������ɢ������
freq=[-20:1:20];
mag=abs(a*sinc(a*freq));
h=stem(freq,mag);
set(h,'LineWidth',3*get(h,'LineWidth'));
x=a*ones(size(t));
title('��ɢ������');
xlabel('f');
grid;

figure(3);
for k=1:m   % ѭ����ʾг������ͼ��
    pause;
    x=x+2*a*sinc(a*k)*cos(2*pi*t*k/T0);
    y(k,:)=x;  % ������Ӻ�
    plot(t,y(m+1,:));
    hold on;
    h=plot(t,y(k,:));  % ���Ƹ��ε����ź�
    set(h,'LineWidth',3*get(h,'LineWidth'));
    hold off;
    grid;
    axis([-(T0+T1/2)-0.5,(T0+T1/2)+0.5,-0.5,1.5]);
    title(strcat(num2str(k),'��г������'));
    xlabel('t');
end

pause;
figure(4)
h=plot(t,y(1:m+1,:));
%axis([-T0/2,T0/2,-0.5,1.5]); % ��ʾһ������
axis([-6,6,-0.5,1.5]); % ��ʾ�������崮
title('����г������');  
xlabel('t');
grid;