function H = class_1_beam_control()
clear all;clc;close all;warning off
% class 1 tensegrity dynamics with a prism control example. 
% [N,Cb,Cs] = tenseg_prism_sidestring(1);
[N,C_b_in,C_s_in] = beamMaster(1,1/10,3);
N(2,6)= N(2,6)+0.01;
Cb = tenseg_ind2C(C_b_in,N);
Cs = tenseg_ind2C(C_s_in,N);
tenseg_plot(N,Cb,Cs);

B = N*Cb';
S=N*Cs';                                                                                                          
%%
% external force on the structure = no external forces ! mwahaha. 
% w1 = [0 0 0]';w2 = [0 0 0]';w3 = [0 0 0]';w4 = [0 0 1]';w5 = [0 0 1]';w6 = [0 0 1]';
% W = 0.*[w1 w2 w3 w4 w5 w6];
W = zeros(3,6);

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
L1 = [1 0 0;
      0 1 0];
R1 = [0 0 0 0 0 1]';
Yt = [0 7/3]';

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
    E1 = [E1;Yt-L1*Nt*R1];
end
E1_want = [];
for i=1:length(E1)
    if rem(i,2)==1
        E1_want = [E1_want;E1(i)]
    end
end
plot(t,E1_want(1:length(t)))
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
end


