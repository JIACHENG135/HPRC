function H = example_class_k_testingljc()
clc;clear all;close all;
warning off
% Dream Catcher 
%EXAMPLE:
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
% N = [n1 n2 n3 n4];
% % 
% % % Specify bar and string connectivity 
% C_b_in = [4 1;  % Bar 1 connects node 4 to node 1
% 	      1 2;  % Bar 2 connects node 1 to node 2
% 		  2 3;  % Bar 3 connects node 2 to node 3
% 		  3 4]; % Bar 4 connects node 3 to node 4
% C_s_in = [2 4;  % String 1 connects node 2 to node 4
% 	      1 3]; % String 2 connects node 1 to node 3
% C_b = tenseg_ind2C(C_b_in,N_simple);
% C_s = tenseg_ind2C(C_s_in,N_simple);
% N=[11 0 0 0];phi=pi/12;q=1;
% [y,Nn,C_b_in,C_s_in]=main(N,phi,q);
% N=Nn(:,1:3)';
% Convert above index notation into actual connectivity matrices
% [NN,phi,q]=MichellWheel(5,pi/12,pi/6,1,3);
[N,phi,q,C_s_in,C_b_in]=MichellWheel_new(0.1,3,5,pi/8);
N3=zeros(length(N(:,1)),1);
N=[N N3]';
N_simple=N;
% N=notation_new(NN,phi,q);
% N=notation(NN,phi,q);
% C_s_in=[];
% C_b_in = [];
% for i=1:q
%     tem=generateCin(1+pi/phi*(i-1),phi);
%     C_s_in=[C_s_in;tem];
% end
% for i = 1 : pi/phi - 1
%    C_b_in = [C_b_in;i i+1];
% end
% C_b_in = [C_b_in;pi/phi 1];
% for i = pi/phi*q+1 : pi/phi*(q+1)-1
%    C_b_in = [C_b_in;i i+1];
% end
% 
% for i = pi/phi*q+1 : pi/phi*(q+1)-1
%    C_s_in = [C_s_in;i i+1];
% end
% C_b_in = [C_b_in;pi/phi*q+1 pi/phi*(q+1)];
% C_s_in = [C_s_in;pi/phi*q+1 pi/phi*(q+1)];
C_b = tenseg_ind2C(C_b_in,N);
C_s = tenseg_ind2C(C_s_in,N);
[N,C_b,C_s,parents] = tenseg_string_segment(N,C_b,C_s,1);

%[N_simple,C_b,C_s,parents] = tenseg_string_segment(N,C_b,C_s,1);

% % pinned_nodes
temp=unique(C_b_in(:));
pinned_nodes = temp(2*pi/phi+1:end);
temp=[];
% pinned_nodes = length(N(1,:))/3+1:length(N(1,:));
% pinned_nodes = length(N(1,:));
% pinned_nodes = [];
% To illustrate the class k conversion process, print the initial number of
% nodes here
disp(['Initial # of nodes: ' num2str(size(N_simple,2))])
tenseg_plot(N_simple,C_b,C_s);
%%
% Convert specified class k structure into a class 1 structure with constraints
[N_new,C_b_new,C_s_new,P,node_constraints,~,string_nodes_index] = tenseg_class_k_convert(N_simple,C_b,C_s,pinned_nodes);
start=find(sum(P,1)~=0,1);
P(:,start:end)=0;
for i=1:length(pinned_nodes)
    P(find(ismember(N_new',N(:,pinned_nodes(i))','rows')==1,1),start-1+i)=1;
%     find(ismember(N_new',N(:,pinned_nodes(i))','rows')==1,1)
end
% [N_new,C_b_new,C_s_new,P] = tenseg_class_k_convert(N_simple,C_b,C_s);
D = zeros(3,size(P,2));
% D(:,(end-2*length(N(1,:))/3+1):end) = N_new(:,length(N(1,:))/3+1:length(N(1,:)));
D(:,end-2*pi/phi+1:end) = N_simple(:,pinned_nodes);
% D(:,end) = N_new(:,length(N_new(1,:)));
% D(:,end) = n1;

% node_constraints=[];
% Print the final number of nodes
disp(['Converted Class K # of nodes:' num2str(size(N_new,2))])

% Print the generated node constraints
disp(['Class K Node constraints:'])
for i=1:numel(node_constraints)
	if numel(node_constraints{i})>1
		disp(['   Coincident nodes: ' num2str(node_constraints{i})])
	end
end
%Specify resting string lengths

% Here, we're setting every string rest length to 70% of its given length
S_0_percent = [(1:size(C_s_new,1))',1.2*ones(size(C_s_new,1),1)]; % percent of initial lengths

% This function converts those specified percentages into rest lengths
s_0 = tenseg_percent2s0(N_new,C_s_new,S_0_percent);
ms = tenseg_massive_string(s_0,N_new,C_s_new,string_nodes_index);
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
classK_test.tf =1.2;
classK_test.dt = .001;
classK_test.video = 1;
classK_test.ms = ms;

% Add Velocity 
V=zeros(3,length(N_new(1,:)));
% V(3,1:length(N(1,:))/3)=-2*ones(1,length(N(1,:))/3);
V(3,1:2*pi/phi)=-10;
% *ones(1,2*pi/phi);
% classK_test.Nd0= V;
% V=zeros(3,length(N_new(1,:)));
% V(1,1)=2*ones(1,1);
classK_test.Nd0= V;


% Add external force
 %classK_test.W= 10*ones(3,length(N_new(1,:)));
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





for i=1:size(Hist.Nhist,3)
Btrace(:,:,i) = Hist.Nhist(:,:,i)*debug.input.C_b';
end

for i=1:size(Hist.Nhist,3)
Strace(:,:,i) = Hist.Nhist(:,:,i)*debug.input.C_s';
end

for i=1:size(Hist.Nhist,3)
RBtrace(:,:,i) = 0.5.*Hist.Nhist(:,:,i)*abs(debug.input.C_b)';
end


for i=1:size(Hist.Nhist,3)
RStrace(:,:,i) = 0.5.*Hist.Nhist(:,:,i)*abs(debug.input.C_s)';
end

H.N = Hist.Nhist;
H.B = Btrace;
H.S = Strace;
H.RB = RBtrace;
H.RS = RStrace;
H.tf = classK_test.tf;
H.dt = classK_test.dt;
end
% % To watch animation agian: tenseg_animation(Hist,classK_seg)