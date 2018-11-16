function  H=tbar_fish_control_vary_Yt(angle,q,points)
clear all
[N,C_b,C_s]=main_fish_uneven(3,'0021');
N = check_if_N_dup(N,C_b,C_s);
ratio = 0.7;
angle = 10;
decay_factor = 1.1;
target = {};
dt = 0.1;tf = 10;
omega = angle/(tf/dt);
[control_point_h,control_point_up,control_point_down] = find_hori_ver_target(N,ratio);
control_point = [control_point_h,control_point_up,control_point_down];
[target_h,target_up,target_down,set_len]=find_target_ud_time(N,control_point_h,control_point_up,control_point_down,[angle*pi/180],decay_factor,omega*pi/180);
%%
for i=1:set_len
target{1,i} = [target_h{1,i} ;target_up{1,i};target_down{1,i}];
end
% plot(target(:,1),target(:,2),'ro'),axis equal

all_hori = find_hori_N(N,0);
pinned_nodes = find_hori_ver_N(N,ratio);
pinned_nodes = [pinned_nodes 16];
C_b_t = C_b;
C_s_t = C_s;
C_b_in=transfer_C_b(N,C_b); 
C_s_in=transfer_C_b(N,C_s);
N_ori = N;
% Convert above index notation into actual connectivity matrices

% [NN,phi,q]=MichellWheel(8,pi/12,pi/6,1,20);
% N=notation(NN,phi,q);
% C_s_in=[];
% C_b_in = [];
% for i=1:q
%     tem=generateCin(1+pi/phi*(i-1),phi);
%     C_s_in=[C_s_in;tem];
% end
% 
% 
% for i = 1 : pi/phi - 1
%    C_b_in = [C_b_in;i i+1];
% end
% C_b_in = [C_b_in;pi/phi 1];
% 
% for i = pi/phi*q+1 : pi/phi*(q+1)-1
%    C_b_in = [C_b_in;i i+1];
% end
% C_b_in = [C_b_in;pi/phi*q+1 pi/phi*(q+1)];
% 



% for i = pi/phi*q+1 : pi/phi*(q+1)-1
%    C_s_in = [C_s_in;i i+1];
% end
% C_s_in = [C_s_in;pi/phi*q+1 pi/phi*(q+1)];


%%Taylor Wheel
% Ninitial=[11 0 0 0];phi=pi/12;q=1;
% [y,Nn,C_b_in,C_s_in]=main(Ninitial,phi,q);
% N=Nn(:,1:3)';
% C_s = tenseg_ind2C(C_s_in,N);
% C_b = tenseg_ind2C(C_b_in,N);
% N=N_simple;
N=N';
N_simple = N;
C_b = tenseg_ind2C(C_b_in,N);
C_s = tenseg_ind2C(C_s_in,N);
% load('N_new.mat')
% N_simple = [0,0.999999999999999,0,2,1,0;0,0,0,0,0,0;-2,-1,0,-4.44089209850063e-16,0.999999999999999,2];
%%
tenseg_plot_target(N_simple,C_b,C_s,target{1,end});

% C_b_in = [6 3;3 1; 4 5; 4 2; 5 3;2 3];
% C_s_in=[6 5;1 2;5 2];

[N_new,Cb,Cs,P,~] = tenseg_class_k_convert(N_simple,C_b,C_s,pinned_nodes);

D = zeros(3,size(P,2));
D(:,end-length(pinned_nodes)+1:end) = N_new(:,pinned_nodes);
% D = N_new * P;
N=N_new;
B = N*Cb';S=N*Cs';b0=sqrt(diag(diag(B'*B)));s0=sqrt(diag(diag(S'*S)));
W = zeros(3,size(N,2));



R = zeros(length(N(1,:)),length(control_point));
% R = zeros(length(N(1,:)),1);

count = 1;
for i=1:length(control_point)
R(control_point(i),count) = 1;
count = count +1 ;
end
% R(6,2) = 1;
% R(2,23) = 1;


L = [1 0 0; 0 0 1];
Yt=target;
%%
warning off
[U,Ez,V] = svd(P);
U1 = U(:,1:size(P,2));U2 = U(:,size(P,2)+1:end); E0 = Ez(1:size(P,2),:);
Nd = 0*N;
x0 = [N*U2 , Nd*U2];
% dt = 0.001; tf = 10;
t = 0:dt:tf;
a=1;
b=0.5;
Inp.V = V;
Inp.a=a;Inp.b=b;Inp.Cs = Cs; Inp.Cb=Cb; Inp.W=W; Inp.s0=s0; Inp.b0=b0;Inp.tf=tf;Inp.P=P;Inp.D=D;Inp.B=B;Inp.S=S;Inp.Yt=Yt;Inp.L=L;Inp.R=R;

% y = ode4(@classkcontrol2,t,x0,Inp);
y = ode41(@classkcontrol2_dyn_yt,t,x0,Inp);
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
%     E = [E;(L*N*R-Yt)];
end
span = [1:2:(length(t)-1)*2]'+1;
err=zeros(length(t)-1,length(target(:,1)));
for i =1:4
%     figure(i+1)
    holld = [1 3 4 6];
%     err(:,i) = E(span,holld(i));
%     err(:,i) = E(span,i);

%     plot(t(1:length(span))/10,err(:,i)),axis([0 tf/10 -0.05 0.05]),hold on
end
% for i =1:length(target(:,1))-3
% %     figure(i+1)
%     err(:,i) = E(span,i);
%     plot(t(1:length(span)),err(:,i)),axis([0 tf -0.05 0.1]),hold on
% end
str=['a=' mat2str(a) '_b=' mat2str(b) '_ratios=' mat2str(ratio) '_decay_factor=' mat2str(decay_factor) 'time'];
% err = [];
% for i = 1:length(target(:,1))
%     err(i)
save (str)
% E =E';
% plot(t,E(1,1:2:size(E,2)),'r'),hold on;
% plot(t,E(2,1:2:size(E,2)),'b');
% plot(t,E(:,1))
% % plot(t,E,t,ble)
% legend('time/s','error')
% legend('x axis','y axis','bar1','bar2','bar3','bar4')
xlabel('Time (sec)')
ylabel('Error (m)')

% % tenseg_plot(N,Cb,Cs)
%%
date1 = datestr(now,5);
cartoon(Ntrace,Cb,Cs,[date1 str '.avi']);    %cartoon of control

H.N = Ntrace;
H.B = Btrace;
H.S = Strace;
H.RB = RBtrace;
H.RS = RStrace;
H.tf = tf;
H.dt = t;
end
