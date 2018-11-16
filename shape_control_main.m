function  H=tbar_fish_control(angle,q,points)
clear all
%%
% load python_01100210.8.mat
angle_tail = 10;
[N,C_b,C_s,C_b_in,C_s_in,target] = dolphin_target_generator('0021',angle_tail,20,0.8);
N = setoff_dup(N)'; 
N_simple = N;

[index_reflection] = re_index_target_nodes('0021',20,0.8);

target_re_index = re_index_target(index_reflection,target);
% target_re_index = target_time_0_u;
tenseg_plot_target_3D(N,C_b,C_s,target_re_index(:,:,end));
% decide which to control
Nx = N(1,:);
part_x = 0.88;pinned_nodes = [];
for i = 1:length(Nx)
    if Nx(i)<part_x
        pinned_nodes = [pinned_nodes i];
    end
end
% [index_reflection] = re_index_target_nodes('0021',20,0.8);
% target(pinned_nodes,:) = [];
%%
% target_re_index = re_index_target(index_reflection,target);
target_re_index(pinned_nodes,:,:)= [];
control_point  = 1:length(N_simple(1,:));
control_point(pinned_nodes) = [];
%%
[N_new,Cb,Cs,P,~] = tenseg_class_k_convert(N_simple,C_b,C_s,pinned_nodes);

D = zeros(3,size(P,2));
D(:,end-length(pinned_nodes)+1:end) = N_new(:,pinned_nodes);
% D = N_new * P;
N=N_new;
B = N*Cb';S=N*Cs';b0=sqrt(diag(diag(B'*B)));s0=sqrt(diag(diag(S'*S)));
W = zeros(3,size(N,2));
L = [1 0 0;0 1 0;0 0 1];
R = zeros(length(N_new(1,:)),length(target_re_index(:,1,1)));

for i =1:length(control_point)
    R(control_point(i),i) = 1;
end

Yt = target_re_index';

[U,Ez,V] = svd(P);
U1 = U(:,1:size(P,2));U2 = U(:,size(P,2)+1:end); E0 = Ez(1:size(P,2),:);
Nd = 0*N;
x0 = [N*U2 , Nd*U2];
dt = 0.01; tf = 10;
% dt = 0.001; tf = 10;
t = 0:dt:tf;
a=2;
b=2;
Inp.a=a;Inp.b=b;Inp.Cs = Cs; Inp.Cb=Cb; Inp.W=W; Inp.s0=s0; Inp.b0=b0;Inp.tf=tf;Inp.P=P;Inp.D=D;Inp.B=B;Inp.S=S;Inp.Yt=Yt;Inp.L=L;Inp.R=R;
Inp.dt = 0.1;Inp.df = 1;
Inp.mn = x0;
%%
% y = ode4(@classkcontrol2,t,x0,Inp);
y = ode41(@classkcontrol2,t,x0,Inp);
X1 = D*V*E0^-1;
%%
% %
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
    666
    E = [E;(L*N*R-Yt(:,:,end))];
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
% str=['a=' mat2str(a) '_b=' mat2str(b) '_ratios=' mat2str(ratio) '_decay_factor=' mat2str(decay_factor)];
% err = [];
% for i = 1:length(target(:,1))
%     err(i)
% save (str)
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
cartoon(Ntrace,Cb,Cs,['Dolphin'  int2str(angle_tail) '.avi'],target_re_index(:,:,end));    %cartoon of control

H.N = Ntrace;
H.B = Btrace;
H.S = Strace;
H.RB = RBtrace;
H.RS = RStrace;
H.tf = tf;
H.dt = t;
end
