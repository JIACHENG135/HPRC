function [N_new_new,N_new_new_index,C_b_new_new,C_s_new_new,P,node_constraints,bar_nodes_index_new,string_nodes_index_new] = tenseg_class_k_convert_ljc(N,C_b,C_s,pinned_nodes)
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
%		indices corresponding to the initial nodes

if nargin < 4,
	pinned_nodes = []; % default pinned nodes
end

% Get class of each node, and total number of virtual nodes
node_class = sum(abs(C_b),1);
number_of_virtual_nodes = sum(node_class)-sum(node_class>0);

n = numel(node_class);

% Initialize matrix of virtual nodes
N_virtual = zeros(3,number_of_virtual_nodes);

% Go through all nodes. If a node has one or more coincident virtual nodes,
% copy that node position into N_virtual. Also create node_constraints
% along the way, which keeps track of which final nodes are constrained to
% be conincident
virtual_node_ind = 1;
for i=1:numel(node_class), % go through each given node
	node_constraints{i}(1) = i;
	for j=1:node_class(i)-1, % go through any virtual nodes for node i
		N_virtual(:,virtual_node_ind) = N(:,i);
		node_constraints{i}(1+j) = n + virtual_node_ind; % log new index
		virtual_node_ind = virtual_node_ind+1;
	end
end
N_new = [N N_virtual]; % combine physical and virtual node matrices
N_newtest=N_new;
% Go through each row of given bar connectivity matrix and move entries for
% class k nodes to the appropriate virtual node indices
C_b_new = C_b;
for i=1:numel(node_constraints)
	for j=1:numel(node_constraints{i})-1
		node_ind = node_constraints{i}(j);
		if node_ind <= size(C_b,2)
			bar_ind = find(abs(C_b(:,node_ind))~=0);
			for k=1:numel(bar_ind)-1
				C_b_new(bar_ind(k+1),node_constraints{i}(k+1)) = C_b_new...
                    (bar_ind(k+1),node_ind);
				C_b_new(bar_ind(k+1),node_ind) = 0;
			end
		end
	end
end

% Pad C_s with zeros to match dimension of new N matrix
C_s_new = [C_s, zeros(size(C_s,1),number_of_virtual_nodes)];


% Generate P constraint matrix
P = [];
% for i=1:numel(node_constraints)
% 	if numel(node_constraints{i})>1
% % 		constraints_to_add = nchoosek(node_constraints{i},2);
% 		constraints_to_add = nchoosek(node_constraints{i}(2:end),1);
%         l = length(constraints_to_add(:,1));
%         Append = node_constraints{i}(1)*ones(l,1);
%         constraints_to_add = [Append constraints_to_add];
% 		P_add = zeros(size(N_new,2),size(constraints_to_add,1));
% 		for j=1:size(constraints_to_add,1)
% 			P_add(constraints_to_add(j,1),j) = 1;
% 			P_add(constraints_to_add(j,2),j) = -1;
% 		end
% 		P = [P P_add];
% 	end
% end


for i=1:numel(node_constraints),
	if numel(node_constraints{i})>1,
		constraints_to_add = nchoosek(node_constraints{i},2);
		P_add = zeros(size(N_new,2),size(constraints_to_add,1));
		for j=1:size(constraints_to_add,1),
			P_add(constraints_to_add(j,1),j) = 1;
			P_add(constraints_to_add(j,2),j) = -1;
		end
		P = [P P_add];
	end
end



% Rearrange stuff to put into form: N = [Nb Ns]
string_nodes_ind = [node_class==0, logical(zeros(1,number_of_virtual_nodes))];
N_s = N_new(:,string_nodes_ind);
N_b = N_new(:,~string_nodes_ind);
N_new = [N_b N_s];
string_nodes_index=[sum(~string_nodes_ind)+1:length(N_new(1,:))];
bar_nodes_index=[1:sum(~string_nodes_ind)];

C_b_s = C_b_new(:,string_nodes_ind);
C_b_b = C_b_new(:,~string_nodes_ind);
C_b_new = [C_b_b C_b_s];

C_s_s = C_s_new(:,string_nodes_ind);
C_s_b = C_s_new(:,~string_nodes_ind);
C_s_new = [C_s_b C_s_s];

if ~isempty(P),
	P_s = P(string_nodes_ind,:);
	P_b = P(~string_nodes_ind,:);
	P = [P_b; P_s];
end


% Generate constraint matrix for pinned nodes
P_pinned = [];
for i=1:numel(pinned_nodes),
	P_add = zeros(size(N_new,2),1);
	P_add(pinned_nodes(i)) = 1;
	P_pinned = [P_pinned P_add];
end

P = [P P_pinned];

%% change by ljc

start=find(sum(P,1)~=0,1);
P(:,start:end)=0;
for i=1:length(pinned_nodes)
    P(find(ismember(N_new',N(:,pinned_nodes(i))','rows')==1,1),start-1+i)=1;
%     find(ismember(N_new',N(:,pinned_nodes(i))','rows')==1,1)
end
[P,N_new_new,char_value_old,char_value_new,N_new_new_index]=tenseg_class_k_countP(N_new,P);
C_b_in = tenseg_c2in(C_b_new);
C_s_in = tenseg_c2in(C_s_new);
% B = N_new * C_b_new';
% S = N_new * C_s_new';
% C_b_new_new=pinv(N_new) * B;
% C_s_new_new=pinv(N_new) * S;
[C_b_new_new,C_s_new_new]=conv_cor_index(C_b_in,C_s_in,N_new_new_index);
C_s_new_new = tenseg_ind2C(C_s_new_new,N_new_new);
C_b_new_new = tenseg_ind2C(C_b_new_new,N_new_new);
bar_nodes_index_new = zeros(size(bar_nodes_index));
string_nodes_index_new = zeros(size(string_nodes_index));
for i =1:length(bar_nodes_index)
    bar_nodes_index_new(i)=find(N_new_new_index(4,:)==bar_nodes_index(i));
end

for i =1:length(string_nodes_index)
    string_nodes_index_new(i)=find(N_new_new_index(4,:)==string_nodes_index(i));
end
end