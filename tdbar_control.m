function  tdbar_control(angle,q,points)
clear all
angle = 10/180*pi;
q=2;
points = [0 0 2 1];
[C_s,C_b,N_simple] = gene_ver_tdbar(angle,q,points);
N_simple = setoff_dup(N_simple);
C_b_in=transfer_C_b(N_simple,C_b); 
C_s_in=transfer_C_b(N_simple,C_s);
N_simple=N_simple';
C_b = tenseg_ind2C(C_b_in,N_simple);
C_s = tenseg_ind2C(C_s_in,N_simple);
tenseg_plot(N_simple,C_b,C_s);

pinned_nodes = [19];
[N_new,Cb,Cs,P,~] = tenseg_class_k_convert(N_simple,C_b,C_s,pinned_nodes);
D = zeros(3,size(P,2));
D(:,end) = N_new(:,length(N_simple(1,:)));
% D = N_new * P;
N=N_new;
B = N*Cb';S=N*Cs';b0=sqrt(diag(diag(B'*B)));s0=sqrt(diag(diag(S'*S)));
W = zeros(3,size(N,2));
R = zeros(length(N(1,:)),1);
R(1) = 1;
% R(2,23) = 1;
L = [1 0 0;0 0 1];
Yt=[0.5;0.25];
[U,Ez,V] = svd(P);
U1 = U(:,1:size(P,2));U2 = U(:,size(P,2)+1:end); E0 = Ez(1:size(P,2),:);
Nd = 0*N;
x0 = [N*U2 , Nd*U2];
dt = 0.01; tf = 5;
% dt = 0.001; tf = 10;
t = 0:dt:tf;
a=1000;
b=1;
Inp.a=a;Inp.b=b;Inp.Cs = Cs; Inp.Cb=Cb; Inp.W=W; Inp.s0=s0; Inp.b0=b0;Inp.tf=tf;Inp.P=P;Inp.D=D;Inp.B=B;Inp.S=S;Inp.Yt=Yt;Inp.L=L;Inp.R=R;
%%
% y = ode4(@classkcontrol2,t,x0,Inp);
y = ode41(@classkcontrol2,t,x0,Inp);
X1 = D*V*E0^-1;

%%
figure(2)
E=[];ble=zeros(size(Cb,1),size(y,1));
for i = 1:size(y,1)
    X2 = (y(i,1:size(y,2)/2));
    X2 = reshape(X2,3,size(U2,2));
    N = [X1 X2]*U^-1;
    Ntrace(:,:,i) = N;
    Btrace(:,:,i) = N*Cb';
    Strace(:,:,i) = N*Cs';
    RBtrace(:,:,i) = 0.5*N*abs(Cb');
    RStrace(:,:,i) = 0.5*N*abs(Cs');
    ble(:,i)=diag(B'*B)-diag(Btrace(:,:,i)'*Btrace(:,:,i));
    E = [E,(L*N*R-Yt)];
end
E =E';
plot(t,E(:,1),t,E(:,2))
% plot(t,E,t,ble)
legend('x axis','y axis')
legend('x axis','y axis','bar1','bar2','bar3','bar4')
xlabel('Time (sec)')
ylabel('Error (m)')
% tenseg_plot(N,Cb,Cs)
%%
cartoon(Ntrace,Cb,Cs,'constrained_dbar_control42.avi');    %cartoon of control

H.N = Ntrace;
H.B = Btrace;
H.S = Strace;
H.RB = RBtrace;
H.RS = RStrace;
H.tf = tf;
H.dt = t;
end
