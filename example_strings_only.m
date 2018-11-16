% EXAMPLE:
%    - Manual node matrix specification
%    - Manual connectivity matrix generation
%    - Barless structure
%    - Manual string rest length specification
%    - Time-varying external forces (see Wtest.m)
%    - Simulation

clear all; clc; close all;

% Specify node positions
% n1 = [0 0 0]';
% n2 = [1 0 0]';
% n3 = [1 1 0]';
% n4 = [0 1 0]';
% N = [n1 n2 n3 n4]; % Build node matrix
% 
% % Specify and build string connectivity matrix
% C_s_in = [1 2; 2 3; 3 4; 4 1; 2 4; 1 3];
% C_s = tenseg_ind2C(C_s_in,N);

% [N,C_b,C_s] = tenseg_prismplate(1,1);
[NN,phi,q]=MichellWheel(7,pi/12,pi/6,1,20);
N=notation(NN,phi,q);
C_s_in=[];
for i=1:q
    tem=generateCin(1+pi/phi*(i-1),phi);
    C_s_in=[C_s_in;tem];
end
% a(a==max(a(:,2)))=1
C_s_in(C_s_in==max(C_s_in(:,2)))=C_s_in(C_s_in==max(C_s_in(:,2)));
C_s = tenseg_ind2C(C_s_in,N);

C_b=[];
[N,C_b,C_s,parents] = tenseg_string_segment(N,C_b,C_s,2);
pinned_nodes=[1 2]
[N_new,C_b_new,C_s_new,P,node_constraints] = tenseg_class_k_convert(N,C_b,C_s,pinned_nodes);
% [N_new,C_b_new,C_s_new,P] = tenseg_class_k_convert(N_simple,C_b,C_s);
D = zeros(3,size(P,2));
% D(:,end) = N_simple(:,1);
D(:,end) = N_new(:,1);
% Plot structure
tenseg_plot(N,[],C_s);

% Specify resting string lengths
% This sets string 5 and 6 rest lengths to 60% of their given lengths
% s_0 = tenseg_percent2s0(N,C_s,[5 0.6; 6 0.6]);
s_0 = [1;0.1];
% Create tensegrity simulation data structure
% Snet.N = N;
Snet.N = N_new;
Snet.C_s = C_s;
Snet.C_b = [];
% Snet.ms = 1;      % set point mass values
% Snet.W = 'W_example'; % specify script that defines external forces at each time step
Snet.s_0 = s_0;
Snet.P = P;
Snet.D = D;
Snet.Nd0 = 1;
Snet.t0 = 0.01;
Snet.y0 = 0.5;
% Perform simulation
tenseg_sim_classkopen(Snet)