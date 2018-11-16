function [Nodes_all,C_b,C_s,C_b_in,C_s_in,target] = dolphin_target_generator_delete(wing_string,theta,number,ratio)
[C_s_cor_all,C_b_cor_all,Nodes_all,ori,size_z]=connect_tri_double(wing_string,number,ratio);

% set_off_dup_N_with_Cm(Nodes_all,C_b_in,C_s_in)
load size_z

% [set_rep,target_set ]= control_panel(ori,size,pi/180*theta,0.8,0.9,wing_string,number);
[new_set,target_set ]= control_panel(ori,size_z,pi/180*theta,ratio,0.9);
target  = [new_set;target_set];
% set
% target_set_new = [set_rep;target_set];
Nodes_all = setoff_dup(Nodes_all);

skin = gene_skin(Nodes_all);

C_b_in = transfer_C_b(Nodes_all,C_b_cor_all);
% C_b_in = unique(C_b_in,'rows');

C_s_in = transfer_C_b(Nodes_all,C_s_cor_all);

[Nodes_all,C_b_in,C_s_in] = set_off_dup_N_with_Cm(Nodes_all,C_b_in,C_s_in);

b = find(C_b_in(:,1)==C_b_in(:,2));
C_b_in(b,:)=[];

c = find(C_s_in(:,1)==C_s_in(:,2));
C_s_in(c,:)=[];
disp('unique')

C_s_in = unique(C_s_in,'rows');
[C_s_in,C_b_in] = set_off_dup_C(C_s_in,C_b_in);
C_b = tenseg_ind2C(C_b_in,Nodes_all);
C_s = tenseg_ind2C(C_s_in,Nodes_all);
% save all
% Nodes_all = Nodes_all';
% tenseg_plot_target_3D(Nodes_all',C_b,C_s,target_set_new);

end
