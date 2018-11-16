function [N_out,C_b_out,C_s_out,info] = tenseg_skin(N,C_b,C_s,iterations,viz)
% [N_out,C_b_out,C_s_out,info] = TENSEG_SKIN(N,C_b,C_s,iterations,viz)
% takes an input tensegrity structure and adds an elastic skin to the
% structure. This is done by first determining the convex hull for the
% input structure. A node is then added at the center of each convex hull
% polygon, and string members are added for each polygon that connect the
% vertices to the center node. Can be repeated for a specified number of
% iterations. Information linking generated skin nodes and string members
% to their parent skin panels is logged.
%
% Inputs:
%	N: Node matrix for input structure
%	C_b: Bar connectivity matrix for input structure
%	C_s: String connectivity matrix for input structure
%	iterations: number of times to repeat polygon generation process
%	viz: Turn visualization on or off
%
% Outputs:
%	N_out: Node matrix for new structure that includes skin
%	C_b_out: Bar connectivity matrix for new structure that includes skin
%	C_s_out: String connectivity for new structure that includes skin
%	info: information about generated skin topology
%		[].parent_panels: node vertices of parent skin panels
%		[].node_parent_ind: parent panel indices for generated skin nodes
%		[].string_parent_ind: parent panle indices for skin strings


% Handle default arguments
if nargin<5,
	viz = 0;
end
if nargin<4,
	iterations = 1;
end

% Get parent skin panels
% if ~tenseg_coplanarN(N) % Use alphavol if 3D
% 	[~,Kout] = alphavol(N');
% 	K_initial = Kout.bnd;
% 	K_initial = sortrows(sort(K_initial,2),1);
% else % Use delaunay if 2D
% 	N_flat = N;
% 	N_flat(~any(N_flat,2),:) = [];
% 	K_initial = delaunay(N_flat(1,:)',N_flat(2,:)');
% end

if viz,
	trisurf(K_initial,N(1,:),N(2,:),N(3,:))
end

% info.parent_panels = K_initial;

% Go through each parent panel, place node at center of panel, and add
% strings connecting new node to panel corners. Repeat for each panel based
% on the number of specified iterations.
% panels = size(K_initial,1);
node_parent_ind = [];
string_parent_ind = [];
for i=1:panels, % Go through each parent panel
	K = K_initial(i,:); % Get vertices for parent panel
	for j=1:iterations, % Loop for specified number of iterations
		K_new = []; N_new = []; C_s_input = [];
		for k=1:size(K,1), % Go through all current panels
			N_new = [N_new, sum(N(:,K(k,:)),2)/numel(K(k,:))]; % Add node at center of panel
			ind_new_node = size(N,2)+size(N_new,2); % Keep track of node index
			C_s_input_new = [K(k,:)', ind_new_node*ones(numel(K(k,:)),1)]; % Add input indices to generate strings connecting new node to panel vertices
			C_s_input = [C_s_input; C_s_input_new];
			K_temp = nchoosek(unique(C_s_input_new),3); % Get panel connectivity for next iteration
			K_new = [K_new; K_temp(2:end,:)];
		end
		K = K_new;
		
		% Log indices of generated nodes and parent skin panel
		node_parent_ind_new = [i*ones(size(N_new,2),1) ((size(N,2)+1):(size(N,2)+size(N_new,2)))'];
		node_parent_ind = [node_parent_ind; node_parent_ind_new];
		
		% Add new nodes to N
		N = [N, N_new];
		
		% Log indices of generated strings and parent skin panel
		string_parent_ind_new = [i*ones(size(C_s_input,1),1) ((size(C_s,1)+1):(size(C_s,1)+size(C_s_input,1)))'];
		string_parent_ind = [string_parent_ind; string_parent_ind_new];
		
		% Generate C_s from index format
		C_s_new = tenseg_ind2C(C_s_input,N);
		
		% Add new C_s matrix to C_s, pad C_b with zeros to match N dimension
		num_of_new_nodes = size(N_new,2);
		C_s = [C_s, zeros(size(C_s,1),num_of_new_nodes); C_s_new];
		C_b = [C_b, zeros(size(C_b,1),num_of_new_nodes)];
	end
end
info.node_parent_ind = node_parent_ind;
info.string_parent_ind = string_parent_ind;

N_out = N;
C_s_out = C_s;
C_b_out = C_b;

if viz
	tenseg_plot(N,C_b,C_s);
end

end