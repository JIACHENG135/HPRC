function [N_new,C_b_new,C_s_new,P,D]= Gene_arm()

%%
clc;clear all;close all;
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
l=1;
alpha=15/180*pi;
% Z coordinates of different surfaces
z1=l/2*tan(alpha);
z23=l/4*tan(alpha);
z47=l/8*tan(alpha);
z8=l*tan(alpha);
% Y coordinates of different surfaces
y1=l/2;
y2=y1+l/4;
y3=y1-l/4;
y4=y2+l/8;
y5=y2-l/8;
y6=y3+l/8;
y7=y3-l/8;
y8=0;
%% Node matrices in cell
NN=cell(1,10);
NN{9}(:,:)= [0 l 0]';
NN{10}(:,:)= [0 0 0]';
NN{1}(:,:)=[
    0 y1 0;
    0 y1 z1;
    3^0.5*z1/2 y1 -z1/2
    -3^0.5*z1/2 y1 -z1/2]';
NN{2}(:,:)=[
    0 y2 0;
    0 y2 z23;
    3^0.5*z23/2 y2 -z23/2
    -3^0.5*z23/2 y2 -z23/2]';
NN{3}(:,:)=[
    0 y3 0;
    0 y3 z23;
    3^0.5*z23/2 y3 -z23/2
    -3^0.5*z23/2 y3 -z23/2]';
NN{4}(:,:)=[
    0 y4 z47;
    3^0.5*z47/2 y4 -z47/2
    -3^0.5*z47/2 y4 -z47/2]';
NN{5}(:,:)=[
    0 y5 z47;
    3^0.5*z47/2 y5 -z47/2
    -3^0.5*z47/2 y5 -z47/2]';
NN{6}(:,:)=[
    0 y6 z47;
    3^0.5*z47/2 y6 -z47/2
    -3^0.5*z47/2 y6 -z47/2]';
NN{7}(:,:)=[
    0 y7 z47;
    3^0.5*z47/2 y7 -z47/2
    -3^0.5*z47/2 y7 -z47/2]';
NN{8}(:,:)=[
    0 y8 z8;
    3^0.5*z8/2 y8 -z8/2
    -3^0.5*z8/2 y8 -z8/2]';

N_simple = [NN{1} NN{2} NN{3} NN{4} NN{5} NN{6} NN{7} NN{8} NN{9} NN{10}];

%% Specify bar and string connectivity 
C_b_in = [2 3;  
	      3 4;
          4 2; % Connection in surf1
          
          6 7;
          7 8;
          8 6;  %Connection in surf2
          
          10 11;
          11 12;
          12 10; %Connection in surf3

          28 13;
          28 14;
          28 15;
          5 13;
          5 14;
          5 15; %Connection in shuttle4
          
          5 16;
          5 17;
          5 18;
          1 16;
          1 17;
          1 18; %Connection in shuttle5
          
          1 19;
          1 20;
          1 21; 
          9 19;
          9 20;
          9 21; %Connection in shuttle6

          9 22;
          9 23;
          9 24;
          29 22;
          29 23;
          29 24;%Connection in shuttle7
          
          25 26;
          25 27;
          26 27];

	
C_s_in = [1 2;% Connection in surf1,2,3
          1 3;
          1 4;
          
          5 6;
          5 7;
          5 8;
          
          9 10;
          9 11;
          9 12;
          
          13 14;% Connection of surf4,5,6,7    
          14 15;
          15 13;
          
          16 17;
          17 18;
          18 16;
          
          19 20;
          20 21;
          21 19;
          
          22 23;
          23 24;
          24 22;
          
%           25 26;
%           26 27;
%           27 25;
          
          6 13;% Connection of between surfaces    
          7 14;
          8 15;
          6 16;
          7 17;
          8 18;
          
          10 19;
          11 20;
          12 21;
          10 22;
          11 23;
          12 24;
          
          2 6;
          3 7;
          4 8;
          2 10;
          3 11;
          4 12;
          2 25;
          3 26;
          4 27;];
      
%       P=[];
%       D=[];

%% Convert above index notation into actual connectivity matrices
C_b = tenseg_ind2C(C_b_in,N_simple);
C_s = tenseg_ind2C(C_s_in,N_simple);

 %[N_simple,C_b,C_s,parents] = tenseg_string_segment(N,C_b,C_s,1);
% pinned_nodes
pinned_nodes = [25 26 27 29];

% Apping force at node 5
W = zeros(size(N_simple));
W(2,28) =10;

%To illustrate the class k conversion process, print the initial number of nodes here
disp(['Initial # of nodes: ' num2str(size(N_simple,2))])
tenseg_plot(N_simple,C_b,C_s);
%%
save N_test
% Convert specified class k structure into a class 1 structure with constraints
[N_new,C_b_new,C_s_new,P,node_constraints] = tenseg_class_k_convert(N_simple,C_b,C_s,pinned_nodes);
% C_b_new = tenseg_ind2C(C_b_in_new,N_new);
% C_s_new = tenseg_ind2C(C_s_in_new,N_new);

D = zeros(3,size(P,2));
% D(:,42)=N_simple(:,25);
% D(:,43)=N_simple(:,26);
% D(:,44)=N_simple(:,27);
% D(:,1)=N_simple(:,29);
D(:,end-3:end)  = N_simple(:,pinned_nodes);

% % node_constraints=[];
% % Print the final number of nodes
% disp(['Converted Class K # of nodes:' num2str(size(N_new,2))])

end
 
 




