function [N_new,C_b_new,C_s_new,Pn,Dn]= class_k_addnode(N,C_b,C_s,P0,D0)
% divide the common nodes of bars into separate nodes

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
for i=1:numel(node_constraints)
	if numel(node_constraints{i})>1
% 		constraints_to_add = nchoosek(node_constraints{i},2);
		constraints_to_add = nchoosek(node_constraints{i}(2:end),1);
        l = length(constraints_to_add(:,1));
        Append = node_constraints{i}(1)*ones(l,1);
        constraints_to_add = [Append constraints_to_add];
		P_add = zeros(size(N_new,2),size(constraints_to_add,1));
		for j=1:size(constraints_to_add,1)
			P_add(constraints_to_add(j,1),j) = 1;
			P_add(constraints_to_add(j,2),j) = -1;
		end
		P = [P P_add];
	end
end

%Pad P0 with zeros to match dimension of new N matrix

P0_new = [P0;zeros(number_of_virtual_nodes,size(P0,2))];

Pn=[P0_new,P];

Dn=[D0,zeros(3,size(P,2))];

end
