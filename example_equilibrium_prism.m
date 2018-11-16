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
% C_b = tenseg_ind2C(C_b_in,N);
C_b = [];
C_s = tenseg_ind2C(C_s_in,N);
[N,C_b,C_s,parents] = tenseg_string_segment(N,C_b,C_s,1);

%[N_simple,C_b,C_s,parents] = tenseg_string_segment(N,C_b,C_s,1);
N_simple = N;
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
% tenseg_plot(N_simple,C_b,C_s);
% Convert specified class k structure into a class 1 structure with constraints
[N_new,C_b_new,C_s_new,P,node_constraints,~,string_nodes_index] = tenseg_class_k_convert(N_simple,C_b,C_s,pinned_nodes);
S_0_percent = [(1:size(C_s_new,1))',1.2*ones(size(C_s_new,1),1)]; % percent of initial lengths
% This function converts those specified percentages into rest lengths
s_0 = tenseg_percent2s0(N_new,C_s_new,S_0_percent);
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
prism.N = N_new;
prism.C_b = C_b_new;
prism.C_s = C_s_new;
prism.s_0 = s_0;
prism.P = P;
prism.D = D;
%W = zeros(size(N));
%W(3,1:3) = -1*ones(1,3);
%W(3,4:6) = 1*ones(1,3);
%prism.W = W;
prism.pinned_nodes = pinned_nodes;
W=zeros(3,length(N(1,:)));
W(2,end)=0.00001;
prism.W = W;
[s0,gamma,s0_per] = tenseg_equil_cvx(prism,[1 1]);
%tenseg_equil(prism)
%%
prism.s_0_const = s0;
prism.c = 0;
prism.video = 1;
History = tenseg_sim_class1open(prism)