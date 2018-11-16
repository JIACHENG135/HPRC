function H = class1dynamics_test()
clear all
clc
format long
% class 1 dynamics 
[N,Cb,Cs] = tenseg_prismplate(1,1);
% [N,Cb,Cs] = tenseg_prism_sidestring(1);
Cb = full(Cb);
Cs = full(Cs);

%% external force on the structure
w1 = [0 0 -1]';w2 = [0 0 -1]';w3 = [0 0 -1]';w4 = [0 0 1]';w5 = [0 0 1]';w6 = [0 0 1]';
W = 0.1*[w1 w2 w3 w4 w5 w6];

S = N*Cs';B=N*Cb';
%% initial lengths of the bars and strings
s0 = sqrt(diag(diag(S'*S)));
b0 = sqrt(diag(diag(B'*B)));

%% simulation
tf = 1;
dt = 0.01;
t = 0:dt:tf;
Nd = 0.*N;
x0 = [N Nd];
Inp.Cs = Cs; Inp.Cb=Cb; Inp.W=W; Inp.s0=s0; Inp.b0=b0;Inp.tf=tf;Inp.m=1;
% figure
y = ode4(@dyn_class_1,t,x0,Inp);
% hold off
for i = 1:size(y,1)
    XN = (y(i,1:size(y,2)/2));
    Nt = reshape(XN,3,size(Cb,2));
    Ntrace(:,:,i) = Nt;
    Btrace(:,:,i) = Nt*Cb';
    Strace(:,:,i) = Nt*Cs';
    RBtrace(:,:,i) = 0.5*Nt*abs(Cb');
    RStrace(:,:,i) = 0.5*Nt*abs(Cs');
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

