%%
%����ɢ�����󣬽��������Ӧ�ĵ�ӳ����Դͼ�񣬴˴��ĵ��ӦԴͼ���һ����
%mark:���ڱ��ͳ�ƿ�Ĳ�����ʽ������-�һ�����-�·�ʽ��0�������ң�1�������£�
%input_Idx����ʾÿ���������ĸ���𣬼�������
%patch_size��ͳ�ƿ�ĳߴ��С��img_rgb��ԭʼͼ��
%row,col ����ͳ�����ݵĴ�С��������ԭʼͼ��Ĵ�С
%%
function [out]=texture_map(img_rgb,row,col,patch_size,input_Idx,mark)
shadow_matrix=zeros(row*patch_size,col*patch_size);
k=max(input_Idx);  %%��Ϊ����0�������
if mark==0       %% left-right
    for i=1:length(input_Idx)
        ii=floor(i/(col));
        jj=mod(i,(col));
        if jj==0
            jj=col;
            ii=ii-1;
        end
        shadow_matrix((ii*patch_size)+1:(ii+1)*patch_size,(jj-1)*patch_size+1:(jj+1)*patch_size)=input_Idx(i);
    end
elseif mark==1   %%up-down
    for i=1:length(input_Idx)
        ii=floor(i/(col));
        jj=mod(i,(col));
        if jj==0
            jj=col;
            ii=ii-1;
        end
        shadow_matrix((ii*patch_size)+1:(ii+2)*patch_size,(jj-1)*patch_size+1:jj*patch_size)=input_Idx(i);
    end
end
figure
imshow(img_rgb);
out=shadow_SB_pro(shadow_matrix,k);
title('up-down');
end