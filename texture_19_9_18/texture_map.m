%%
%用于散点聚类后，将各个类对应的点映射至源图像，此处的点对应源图像的一个块
%mark:用于标记统计块的操作方式，即左-右或者上-下方式；0代表左右，1代表上下；
%input_Idx：表示每个点属于哪个类别，即聚类结果
%patch_size：统计块的尺寸大小；img_rgb：原始图像
%row,col 代表统计数据的大小，并不是原始图像的大小
%%
function [out]=texture_map(img_rgb,row,col,patch_size,input_Idx,mark)
shadow_matrix=zeros(row*patch_size,col*patch_size);
k=max(input_Idx);  %%因为含有0，即噪点
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