function H = class_k_prism_test()
clear all;clc;close all;
% class k tensegrity dynamics with a prism example. 
[N,Cb,Cs] = tenseg_prism_sidestring(1);
B = N*Cb';S=N*Cs';b0=diag(diag(B'*B));s0=diag(diag(S'*S));
% fix the bottom 3 nodes to ground
P = [1 0 0;
     0 1 0;
     0 0 1;
     0 0 0;
     0 0 0;
     0 0 0];
D = [N(:,1) N(:,2) N(:,3)];

% external force on the structure
w1 = [0 0 0]';w2 = [0 0 0]';w3 = [0 0 0]';w4 = [0 0 1]';w5 = [0 0 1]';w6 = [0 0 1]';
W = -1.*[w1 w2 w3 w4 w5 w6];

%% run the class K Dynamics
[U,E,V] = svd(P);
U1 = U(:,1:size(P,2));U2 = U(:,size(P,2)+1:end); E0 = E(1:size(P,2),:);
Nd = 0*N;
x0 = [N*U2 , Nd*U2];
dt = 0.01; tf = 1;
t = 0:dt:tf;
Inp.Cs = Cs; Inp.Cb=Cb; Inp.W=W; Inp.s0=s0; Inp.b0=b0;Inp.tf=tf;Inp.P=P;Inp.D=D;Inp.B=B;Inp.S=S;
y = ode4(@dyn_class_k,t,x0,Inp);
X1 = D*V*E0^-1;
for i = 1:size(y,1)
    X2 = (y(i,1:size(y,2)/2));
    X2 = reshape(X2,3,size(U2,2));
    N = [X1 X2]*U';
    Ntrace(:,:,i) = N;
    Btrace(:,:,i) = N*Cb';
    Strace(:,:,i) = N*Cs';
    RBtrace(:,:,i) = 0.5*N*abs(Cb');
    RStrace(:,:,i) = 0.5*N*abs(Cs');
    diag(B'*B)-diag(Btrace(:,:,i)'*Btrace(:,:,i))
end
H.N = Ntrace;
H.B = Btrace;
H.S = Strace;
H.RB = RBtrace;
H.RS = RStrace;
H.tf = tf;
H.dt = t;
end