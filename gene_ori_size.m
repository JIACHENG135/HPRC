function [ori,size]=gene_ori_size(wing_string,number)
[xU,zU,xL,zL] = devide_x_n(wing_string,number);
ori = [];
size = [];
for i = 1:length(xU)
    ori = [ori;xU(i) 0 0];
    size = [size zU(i)];
end
ori = ori(1:end-1,:);
size = size(2:end);
end