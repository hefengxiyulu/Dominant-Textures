%% ʵ��PCA����ѹ��
function  pca_comp_show(mul,n)
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % �ú���������ʾ����PCAѹ�����ͼ��
% % %  param��
% % %     mul--����Ķ���׻��߸߹���ͼ��  
% % %     n--ָ���ö��ٸ����ɷ�
% % % @author��chaolei
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
[vector ,value,tempMul] = my_pca(mul);
% ʹ����������Ҫ��n�����ɷ�,����ԭ��ԭͼ���С
% PCA��任
% ԭʼ����reshape*������������*������������'
re = tempMul*vector(:,1:n)*vector(:,1:n)';
[r,c,bands] =size(mul);
comp = reshape(re,[r,c,bands]);

str =sprintf('%d%s',n,'�����ɷ�');
figure;imshow(comp);title(str);
end