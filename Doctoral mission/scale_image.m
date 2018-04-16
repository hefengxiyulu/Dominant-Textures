function out=scale_image(data,patch_size)
component=blkproc(data,[patch_size patch_size], 'sum2')./(patch_size*patch_size);
out=component;