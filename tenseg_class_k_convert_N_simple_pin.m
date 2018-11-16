% function [N_new,C_b_new,C_s_new,P,node_constraints,bar_nodes_index,string_nodes_index] = tenseg_class_k_convert_master(N_new,C_b_new,C_s_new,P,node_constraints,bar_nodes_index,string_nodes_index)
 function N_simple_pin = tenseg_class_k_convert_N_simple_pin(N_simple,pinned_nodes)
 N_simple(4,:)=1:length(N_simple(1,:));
 N_simple_pin = N_simple(:,pinned_nodes);
 N_simple(:,pinned_nodes)=[];
 N_simple_pin=[N_simple_pin N_simple];
 end
 
% %%
%  function [N,pinned_nodes] = tenseg_class_k_convert_master(N,pinned_nodes)
% pinned_nodes=pinned_nodes;
% [a,b]=size(P);
% % c=b-a/2;
% N_new_start=N_new(:,a/2+1:end);    
% N_new_end=N_new(:,1:a/2);
% N_new=[N_new_start N_new_end];
%  end
% %%



% [N_new,C_b_new,C_s_new,P,node_constraints] =
% TENSEG_CLASS_K_CONVERT(N,C_b,C_s,pinned_nodes) converts a given class k
% tensegrity structure into a corresponding class 1 structure with
% constrained physical and virtual nodes
% 
% Inputs:
%	N: Initial (class k) node matrix
%	C_b: Initial bar connectivity matrix
%	C_s: Initial string connectivity matrix
%	pinned_nodes (optional): indices of nodes that are pinned in place
%
% Outputs:
%	N_new: Converted node matrix with physical and virtual nodes
%	C_b_new: Converted bar connectivity matrix ''
%	C_s_new: Converted string connectivity matrix ''
%	P: Constraint matrix satisfying N*P = D
%	node_constraints: Cell array in which each cell gives constrained node
