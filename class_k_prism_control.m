
% control of the class k tensegrity prism. 
% the objective of this output feedback control is to drive the prism top
% plate to the target position
function H = class_k_prism_control()
clear all;clc;close all;warning off
% class k tensegrity dynamics with a prism example. 
[N,Cb,Cs] = tenseg_prism_sidestring(1);

B = N*Cb';S=N*Cs';b0=sqrt(diag(diag(B'*B)));s0=sqrt(diag(diag(S'*S)));
% fix the bottom 3 nodes to ground
P = [1 0 0;
     0 1 0;
     0 0 1;
     0 0 0;
     0 0 0;
     0 0 0];
D = [N(:,1) N(:,2) N(:,3)];

% external force on the structure = no external forces ! mwahaha. 
w1 = [0 0 0]';w2 = [0 0 0]';w3 = [0 0 0]';w4 = [0 0 1]';w5 = [0 0 1]';w6 = [0 0 1]';
W = -0.*[w1 w2 w3 w4 w5 w6];

% find the target node positions : 
L = [0 0 1];
R = [0 0 0;
     0 0 0;
     0 0 0;
     1 0 0;
     0 1 0;
     0 0 1];
Yt = [1.2 1.2 1.2];
% control
% [U,Ez,V] = svd(P);
% U1 = U(:,1:size(P,2));
% U2 = U(:,size(P,2)+1:end);
% E0 = Ez(1:size(P,2),:);
[U,SIGMA,V] = svd(P);
rank_SIGMA = rank(SIGMA);
U2 = U(:,rank_SIGMA+1:end);
E0 = SIGMA(1:rank_SIGMA,:);
Nd = 0*N;
x0 = [N*U2 , Nd*U2];
dt = 0.1; tf = 20;
t = 0:dt:tf;
pole = 1;
a=2;
b=2;
Inp.a=a;Inp.b=b;Inp.Cs = Cs; Inp.Cb=Cb; Inp.W=W; Inp.s0=s0; Inp.b0=b0;Inp.tf=tf;Inp.P=P;Inp.D=D;Inp.B=B;Inp.S=S;Inp.Yt=Yt;Inp.L=L;Inp.R=R;
y = ode4(@classkcontrol,t,x0,Inp);
X1 = D*V*E0^-1;
figure
E=[];
for i = 1:size(y,1)
    X2 = (y(i,1:size(y,2)/2));
    X2 = reshape(X2,3,size(U2,2));
    N = [X1 X2]*U^-1;
    Ntrace(:,:,i) = N;
    Btrace(:,:,i) = N*Cb';
    Strace(:,:,i) = N*Cs';
    RBtrace(:,:,i) = 0.5*N*abs(Cb');
    RStrace(:,:,i) = 0.5*N*abs(Cs');
    diag(B'*B)-diag(Btrace(:,:,i)'*Btrace(:,:,i))
    E = [E;L*N*R-Yt];
end
plot(t,E(:,1),t,E(:,2),t,E(:,3))
title('Error vs time plot')
xlabel('Time (sec)')
ylabel('Error (m)')
legend('N4','N5','N6')
H.N = Ntrace;
H.B = Btrace;
H.S = Strace;
H.RB = RBtrace;
H.RS = RStrace;
H.tf = tf;
H.dt = t;
end