% function H = class_k_tdbar_control()
clear all;clc;close all;warning off;
[N,Cb,Cs,P,D] = TDbarstructure(1,60);
% [N,C_b_in,C_s_in]=gen_fish(3,0.02,[0.2,0.08,0.12]);
% Cb=tenseg_ind2C(C_b_in,N);
% Cs=tenseg_ind2C(C_s_in,N);
B = N*Cb';S=N*Cs';b0=sqrt(diag(diag(B'*B)));s0=sqrt(diag(diag(S'*S)));
%define external force
W = zeros(3,size(N,2));

% target control params
% L = [1 0 0;
%      0 1 0];
% R = [0 0 0 0 0 1 0 0 0 0]';
% Yt = [1;1];
L = [1 0 0];R = [1 0 0 0 0 0 0 0]';
Yt=[1.1];

[U,Ez,V] = svd(P);
U1 = U(:,1:size(P,2));U2 = U(:,size(P,2)+1:end); E0 = Ez(1:size(P,2),:);
Nd = 0*N;
x0 = [N*U2 , Nd*U2];
dt = 0.1; tf = 2;
t = 0:dt:tf;
a=10;
b=10;
Inp.a=a;Inp.b=b;Inp.Cs = Cs; Inp.Cb=Cb; Inp.W=W; Inp.s0=s0; Inp.b0=b0;Inp.tf=tf;Inp.P=P;Inp.D=D;Inp.B=B;Inp.S=S;Inp.Yt=Yt;Inp.L=L;Inp.R=R;
y = ode4(@classkcontrol2,t,x0,Inp);
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
    diag(B'*B)-diag(Btrace(:,:,i)'*Btrace(:,:,i));
    E = [E;(L*N*R-Yt)];
end
plot(t,E(:,1))
legend('x axis','y axis')
xlabel('Time (sec)')
ylabel('Error (m)')
H.N = Ntrace;
H.B = Btrace;
H.S = Strace;
H.RB = RBtrace;
H.RS = RStrace;
H.tf = tf;
H.dt = t;
% end