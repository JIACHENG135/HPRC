% EXAMPLE:
%    - Manual node matrix specification
%    - Manual connectivity matrix generation
%    - Class k conversion
%    - Solving equilibrium prestress condition for class k structure
%    - Break strings into segments with point masses
%    - Class k simulation

clear all; clc; close all;

% Specify initial node positions for class k structure
%   - Note that you don't have to worry about converting class k nodes into
%     constrained class 1 physical and virtual nodes yourself.
% n1 = [0 0 0]';
% n2 = [1 0 0]';
% n3 = [1 1 0]';
% n4 = [0 1 0]';
% n5 = [0 -1 0]';
% N_simple = [n1 n2 n3 n4 n5];
% 
% % Specify bar and string connectivity 
% C_b_in = [4 1;  % Bar 1 connects node 4 to node 1
% 	      1 2;  % Bar 2 connects node 1 to node 2
% 		  2 3;  % Bar 3 connects node 2 to node 3
% 		  3 4;
%           5 1]; % Bar 4 connects node 3 to node 4
% C_s_in = [2 4;  % String 1 connects node 2 to node 4
% 	      1 3;
%           ]; % String 2 connects node 1 to node 3
% C_b = tenseg_ind2C(C_b_in,N_simple);
% C_s = tenseg_ind2C(C_s_in,N_simple);
[N,C_b,C_s]=main_fish(4,[0 0.5;0.5 1],'2412');
C_b_t = C_b;
C_s_t = C_s;
C_b_in=transfer_C_b(N,C_b);
C_s_in=transfer_C_b(N,C_s);
% Convert above index notation into actual connectivity matrices

% [NN,phi,q]=MichellWheel(8,pi/12,pi/6,1,20);
% N=notation(NN,phi,q);
% C_s_in=[];
% C_b_in = [];
% for i=1:q
%     tem=generateCin(1+pi/phi*(i-1),phi);
%     C_s_in=[C_s_in;tem];
% end
% 
% 
% for i = 1 : pi/phi - 1
%    C_b_in = [C_b_in;i i+1];
% end
% C_b_in = [C_b_in;pi/phi 1];
% 
% for i = pi/phi*q+1 : pi/phi*(q+1)-1
%    C_b_in = [C_b_in;i i+1];
% end
% C_b_in = [C_b_in;pi/phi*q+1 pi/phi*(q+1)];
% 



% for i = pi/phi*q+1 : pi/phi*(q+1)-1
%    C_s_in = [C_s_in;i i+1];
% end
% C_s_in = [C_s_in;pi/phi*q+1 pi/phi*(q+1)];


%%Taylor Wheel
% Ninitial=[11 0 0 0];phi=pi/12;q=1;
% [y,Nn,C_b_in,C_s_in]=main(Ninitial,phi,q);
% N=Nn(:,1:3)';
% C_s = tenseg_ind2C(C_s_in,N);
% C_b = tenseg_ind2C(C_b_in,N);
% N=N_simple;
N=N';
C_b = tenseg_ind2C(C_b_in,N);
C_s = tenseg_ind2C(C_s_in,N);

% [N] = TensegrityWheel_Nodal(q,r,R,alpha);
% [N,C_b,C_s,parents] = tenseg_string_segment(N,C_b,C_s,1);
N_simple=N;
[N_simple,C_b,C_s,parents] = tenseg_string_segment(N,C_b,C_s,1);

% % pinned_nodes
% pinned_nodes = [1:pi/phi];
pinned_nodes = [length(N_simple(1,:))];
% To illustrate the class k conversion process, print the initial number of
% nodes here
disp(['Initial # of nodes: ' num2str(size(N_simple,2))])
tenseg_plot(N_simple,C_b,C_s);
%%
% Convert specified class k structure into a class 1 structure with constraints
[N_new,C_b_new,C_s_new,P,node_constraints] = tenseg_class_k_convert(N_simple,C_b,C_s,pinned_nodes);
% [N_new,C_b_new,C_s_new,P] = tenseg_class_k_convert(N_simple,C_b,C_s);
D = zeros(3,size(P,2));
D(:,end) = N_new(:,length(N_simple(1,:)));
% D(:,end-pi/phi+1:end) = N_simple(:,1:pi/phi);

% node_constraints=[];
% Print the final number of nodes
disp(['Converted Class K # of nodes:' num2str(size(N_new,2))])
%%

% Print the generated node constraints
disp(['Class K Node constraints:']);
for i=1:numel(node_constraints)
	if numel(node_constraints{i})>1
		disp(['   Coincident nodes: ' num2str(node_constraints{i})]);
	end
end
%%
%Specify resting string lengths

% Here, we're setting every string rest length to 70% of its given length
S_0_percent = [(1:size(C_s_new,1))', 1*ones(size(C_s_new,1),1)]; % percent of initial lengths

% This function converts those specified percentages into rest lengths
s_0 = tenseg_percent2s0(N_new,C_s_new,S_0_percent);

% % Solve prestress equilibrium condition (of system BEFORE segmentation) 
% %    given a condition
% prestress_given = [1 0.9]; % String 1 rest length is 70% of its length
% [s_0_equil,gamma_equil,s_0_percent] = tenseg_equil(classK_test,prestress_given);

%% Simulation 

% Create data structure of system BEFORE segmentation
classK_test.N = N_new;
classK_test.C_b = C_b_new;
classK_test.C_s = C_s_new;
classK_test.P = P;
classK_test.D = D;
classK_test.s_0 = s_0;
classK_test.tf = 1;
classK_test.dt = .1;
classK_test.video = 1;
% Add Velocity 
% V=zeros(3,length(N_new(1,:)));
% V(3,1:length(N(1,:))/3)=-3*ones(1,length(N(1,:))/3);
% V(1,1)=1*ones(1,1);
% classK_test.Nd0= V;

% Add external force
%  classK_test.W= 10*ones(3,length(N_new(1,:)));

 a=zeros(3,length(N_new(1,:)));
 a(1,1)=3;
 classK_test.W=a;

%%
% Perform simulation
[Hist,debug] = tenseg_sim_classkopen(classK_test);


% %%
% % Get string segments' rest lengths
% 

% % Break strings into segments with point masses
% string_mass_assign = 0.1;
% [N_seg,C_b_seg,C_s_seg,parents,ms] = tenseg_string_segment(N_new,C_b_new,C_s_new,5,string_mass_assign);
% P_seg = [P; zeros(size(N_seg,2)-size(P,1),size(P,2))];
% 
% % Plot the structure
% tenseg_plot(N_seg,C_b_seg,C_s_seg);


% % Set rest lengths of segments from the original string 1 equal to rest
% %   length percentage determined above. Do same for original string 2, but
% %   adjust slightly to induce motion.
% s_0_assign = [1 s_0_percent(1); 2 0.6*s_0_percent(2)];
% s_0 = tenseg_percent2s0(N_seg,C_s_seg,s_0_assign,parents);
% 
% 
% classK_seg.N = N_seg;
% classK_seg.C_b = C_b_seg;
% classK_seg.C_s = C_s_seg;
% classK_seg.P = P_seg;
% classK_seg.s_0 = s_0;
% classK_seg.ms = ms;
% 
% % Specify final simulation time
% %   - short because current method involves numerically solving for the
% %     lagrange multipliers at each time step
% classK_seg.tf = 0.5;
% 
% %%
% % Perform simulation
% [Hist,debug] = tenseg_sim_classkopen(classK_seg);
% 
% % To watch animation agian: tenseg_animation(Hist,classK_seg)