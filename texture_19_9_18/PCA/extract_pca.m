%% ��ȡ����ʾPCA�ĸ����ɷ�
function extract_pca(mul)
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % �ú���������ȡ����ʾpca�ĸ������ɷ�
% % %   param��
% % %       mul--����ͼ���Ƕ����ͼ����߸߹���ͼ��
% % %  @author��chaolei
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
[r,c,bands]=size(mul);
[vector,~,tempMul]= my_pca(mul);
% Y=AX��X����Ϊ��������X��Ϊ��������Y =XA��
% PCA���任
PC = tempMul*vector; 
% ��ȡ�����ͼ��ĸ������ɷ�
for i = 1:bands
    outPic = PC(:,i);
    min_value = min(outPic);
    max_value = max(outPic);
    outPic = reshape(outPic,[r,c]);
    figure;
    str = sprintf('%s%d%s','��',i,'���ɷ�');
    imshow(outPic,[min_value,max_value]);title(str);
%     filename = sprintf('%d%s',i,'.jpg');
%     imwrite(outPic,filename);
end
end