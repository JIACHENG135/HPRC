function  H=tbar_fish_control(angle,q,points)
clear all
[N,C_b,C_s]=main_fish_uneven(3,'0012');
N = check_if_N_dup(N,C_b,C_s);
ratio = 0.3;   
angle = 0;
decay_factor = 1.1;
target={};
[control_point_h,control_point_up,control_point_down] = find_hori_ver_target(N,ratio);
control_point = [control_point_h,control_point_up,control_point_down];
% [target_h,target_up,target_down,set_len]=find_target_ud_time(N,control_point_h,control_point_up,control_point_down,[angle*pi/180],decay_factor,1*pi/180);
[target_h,target_up,target_down,set_len]=find_target_ud(N,control_point_h,control_point_up,control_point_down,[angle*pi/180],decay_factor);


target= [target_h  ;target_up ;target_down];
%%
% plot(target(:,1),target(:,2),'ro'),axis equal

all_hori = find_hori_N(N,0);
pinned_nodes = find_hori_ver_N(N,ratio);
pinned_nodes = [pinned_nodes 16];

C_b_t = C_b;
C_s_t = C_s;
C_b_in=transfer_C_b(N,C_b); 
C_s_in=transfer_C_b(N,C_s);
N=N';
N_simple = N;
C_b = tenseg_ind2C(C_b_in,N);
C_s = tenseg_ind2C(C_s_in,N);

tenseg_plot_target(N_simple,C_b,C_s,target(:,:,end));

[N_new,Cb,Cs,P,~] = tenseg_class_k_convert(N_simple,C_b,C_s,pinned_nodes);

D = zeros(3,size(P,2));
D(:,end-length(pinned_nodes)+1:end) = N_new(:,pinned_nodes);
N=N_new;
B = N*Cb';S=N*Cs';b0=sqrt(diag(diag(B'*B)));s0=sqrt(diag(diag(S'*S)));
W = zeros(3,size(N,2));
R = zeros(length(N(1,:)),length(control_point));


count = 1;
for i=1:length(control_point)
R(control_point(i),count) = 1;
count = count +1 ;
end

L = [1 0 0; 0 0 1];
Yt=target';

[U,Ez,V] = svd(P);
U1 = U(:,1:size(P,2));U2 = U(:,size(P,2)+1:end); E0 = Ez(1:size(P,2),:);
Nd = 0*N;
x0 = [N*U2 , Nd*U2];
dt = 0.04; tf = 10;
% dt = 0.001; tf = 10;
t = 0:dt:tf;
a=2;
b=2;
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
    E = [E;(L*N*R-Yt)];
end
span = [1:2:(length(t)-1)*2]'+1;
err=zeros(length(t)-1,length(target(:,1)));
for i =1:4
%     figure(i+1)
    holld = [1 3 4 6];
    err(:,i) = E(span,holld(i));
%     err(:,i) = E(span,i);

    plot(t(1:length(span))/10,err(:,i)),axis([0 tf/10 -0.05 0.05]),hold on
end
% for i =1:length(target(:,1))-3
% %     figure(i+1)
%     err(:,i) = E(span,i);
%     plot(t(1:length(span)),err(:,i)),axis([0 tf -0.05 0.1]),hold on
% end
str=['a=' mat2str(a) '_b=' mat2str(b) '_ratios=' mat2str(ratio) '_decay_factor=' mat2str(decay_factor)];
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
cartoon(Ntrace,Cb,Cs,[str '.avi']);    %cartoon of control

H.N = Ntrace;
H.B = Btrace;
H.S = Strace;
H.RB = RBtrace;
H.RS = RStrace;
H.tf = tf;
H.dt = t;
end
