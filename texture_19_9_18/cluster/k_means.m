function [ output ] = k_means(data, k_value)
% ���ܣ�ʵ��K-means�㷨�ľ��๦�ܣ�
% ���룺    data, Ϊһ�� ���� M��N�� ��ʾ������������M��ʾ����M����������N��ʾÿһ��������ά�ȣ�
%           k_value, ��ʾ����������Ŀ��
% �����    output, ��һ�������� M��������ʾÿһ���������ڵ�����ţ�
% ���ߣ� ����壻
% ʱ�䣺 2017��10��14��
%% �������У����ѡȡK��������Ϊ��ʼ�ľ������ģ�
data_num = size(data, 1);
temp = randperm(data_num, k_value)';     %����û� 
center = data(temp, :);
%% ���ڼ�������������
iteration =0;
while 1
    %�����������������ĵľ��룻
    distance = euclidean_distance(data, center);
    %����������ÿһ�д�С�������� �����Ӧ��indexֵ����ʵ����ֻ��Ҫindex�ĵ�һ�е�ֵ��
    [~, index] = sort(distance, 2, 'ascend');
    
    %�������γ��µľ������ģ�
    center_new = zeros(k_value, size(data, 2));
    for i = 1:k_value
        data_for_one_class = data(index(:, 1) == i, :);          
        center_new(i,:) = mean(data_for_one_class, 1);    %��Ϊ��ʼ�ľ�������Ϊ�������е�Ԫ�أ����Բ������ĳ������������Ϊ0�������
    end
    %����������������۾�һ��������
    iteration = iteration + 1;
    fprintf('���е�������Ϊ��%d\n', iteration);
    
    % ��������εľ������Ĳ��䣬��ֹͣ����������ѭ����
    if center_new == center
        break;
    end
    
    center = center_new;
end

output = index(:, 1);
    
end