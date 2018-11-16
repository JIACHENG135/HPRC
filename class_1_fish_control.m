% function H = class_1_prism_control()
clear all;clc;close all;warning off
% class 1 tensegrity dynamics with a prism control example. 
% [N,Cb,Cs] = tenseg_prism_sidestring(1);
N = [0 1 1 1;0 0 0.2 -0.2;0 0 0 0];
C_b_in = [1 2];
C_s_in = [1 3;1 4];
Cb = tenseg_ind2C(C_b_in,N);
Cs = tenseg_ind2C(C_s_in,N);
% [N_new,C_b_new,C_s_new,P,node_constraints,~,string_nodes_index] = tenseg_class_k_convert(N,Cb,Cs,pinned_nodes);
P=[1 0 0 0;0 1 0 0;0 0 1 1]';

B = N*Cb';S=N*Cs';

% external force on the structure = no external forces ! mwahaha. 
% w1 = [0 0 0]';w2 = [0 0 0]';w3 = [0 0 0]';w4 = [0 0 1]';w5 = [0 0 1]';w6 = [0 0 1]';
% W = 0.*[w1 w2 w3 w4 w5 w6];
W = zeros(3,4);

% find the target node positions : 
% L1 = [1 0 0;
%       0 1 0];
% R1 = [1 0 0 0 0 0;
%       0 1 0 0 0 0;
%       0 0 1 0 0 0;
%       0 0 0 1 0 0;
%       0 0 0 0 1 0;
%       0 0 0 0 0 1];
% 
% Yt = [0 0 0 0 0 0;
%        0 0 0 0 0 0];
L1 = [1 0 0];
R1 = [1 0 0 0]';
Yt = 0.75;

%% initial lengths of the bars and strings
s0 = sqrt(diag(diag(S'*S)));
b0 = sqrt(diag(diag(B'*B)));

%% simulation
tf = 30;
dt = 0.1;
t = 0:dt:tf;
Nd = 0.*N;
x0 = [reshape(N,[],1); reshape(Nd,[],1)];
Inp.Cs = Cs; Inp.Cb=Cb; Inp.W=W; Inp.s0=s0; Inp.b0=b0;Inp.tf=tf;Inp.m=1;
Inp.L1=L1;Inp.R1=R1;Inp.Yt=Yt;%Inp.Y2t=Y2t;Inp.L2=L2;Inp.R2=R2;
y = ode4(@class1control,t,x0,Inp);

E1=[];E2=[];
for i = 1:size(y,1)
    XN = (y(i,1:size(y,2)/2));
    Nt = reshape(XN,3,size(Cb,2));
    Ntrace(:,:,i) = Nt;
    Btrace(:,:,i) = Nt*Cb';
    Strace(:,:,i) = Nt*Cs';
    RBtrace(:,:,i) = 0.5*Nt*abs(Cb');
    RStrace(:,:,i) = 0.5*Nt*abs(Cs');
    diag(B'*B)-diag(Btrace(:,:,i)'*Btrace(:,:,i));
    E1 = [E1;Yt-L1*Nt*R1]
end
plot(t,E1)
xlabel('time (sec)');
ylabel('Error (m)');
title('Error vs Time');
H.N = Ntrace;
H.B = Btrace;
H.S = Strace;
H.RB = RBtrace;
H.RS = RStrace;
H.tf = tf;
H.dt = t;
hold off;
% end


