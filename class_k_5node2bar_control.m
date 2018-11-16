
% control of the class k 'x-bar'. 
% the objective of this output feedback control is to drive nodes 3,4 from
% initial position to be on a semi-circle
function H=class_k_5node2bar_control()
clear all;clc;close all;warning off
% class k tensegrity dynamics with a prism example. 
N = [0 10 2 8; 0 0 -0.01 -0.10 ;0 0 0 0 ];
C_b_in = [1 3;2 4];
C_s_in = [1 3; 3 4; 4 2];
% C_s_in = [1 5; 2 5; 1 4; 2 3; 4 3; 4 5; 3 5];
Cb = tenseg_ind2C(C_b_in,N);
Cs = tenseg_ind2C(C_s_in,N);
B = N*Cb';S=N*Cs';b0=sqrt(diag(diag(B'*B)));s0=sqrt(diag(diag(S'*S)));
% fix the nodes 1,2 to ground
P = [1 0; 0 1; 0 0; 0 0;];
D = [N(:,1) N(:,2)];

% external force on the structure = no external forces ! mwahaha. 
% w1 = [0 0 0]';w2 = [0 0 0]';w3 = [0 0 0]';w4 = [0 0 1]';w5 = [0 0 1]';
% W = -0.*[w1 w2 w3 w4 w5];

w1 = [0 0 0]';w2 = [0 0 0]';w3 = [0 0 0]';w4 = [0 0 1]';w5 = [0 0 1]';
W = -0.*[w1 w2 w3 w4];

% find the target node positions : 
L = [1 0 0; 0 1 0];
R = [0 0 1 0 ; 0 0 0 1]';
Yt = [3.6 6.4 ;4.8 4.8;];
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
% plot(t,E(:,1),t,E(:,2))
% title('Error vs time plot')
% xlabel('Time (sec)')
% ylabel('Error (m)')
% legend('N1','N2')
H.N = Ntrace;
H.B = Btrace;
H.S = Strace;
H.RB = RBtrace;
H.RS = RStrace;
H.tf = tf;
H.dt = t;
end