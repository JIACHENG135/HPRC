function [C_s_cor,C_b_cor,Nodes] = td_t_bar_gene(cor,size)
%%
% give the cordinates of inner point, then generate C_b,C_s,_Nodes
x = cor(1);
y = cor(2);
z = cor(3);
ori = [y z];
p1 = ori + [0 size];
p2 = rotanew(ori+[0 size],ori,pi/3*2);
p3 =  rotanew(ori+[0 size],ori,pi/3*4);
p = [p1;p2;p3];
p = [[x;x;x] p];
C_b_cor = [x ori x p1;x ori x p2;x ori x p3];
C_s_cor = [x p1 x p2; x p2 x p3; x p3 x p1];
Nodes = [cor;x p1;x p2;x p3];
C_b_in = transfer_C_b(Nodes,C_b_cor);
C_s_in = transfer_C_b(Nodes,C_s_cor);
C_b = tenseg_ind2C(C_b_in,Nodes);
C_s = tenseg_ind2C(C_s_in,Nodes);
% tenseg_plot(Nodes',C_b,C_s)
end
