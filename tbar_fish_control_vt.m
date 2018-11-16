function  H=tbar_fish_control_vt()
%%
clear all
%
% [~,~,~,~,~,file_name]=gene_target_nodes_for_python(0.1,1,50,20,'0021',0.8,'dolphin');
% load(file_name)
load dolphintd0.1tf1theta50number200021ratio0.8.mat
angle_tail = 50;
[N,C_b,C_s,~,~,target] = dolphin_target_generator('0021',angle_tail,20,0.8);
N = setoff_dup(N)'; 
N_simple = N;

% [index_reflection] = re_index_target_nodes('0021',20,0.8);


% decide which to control
% Nx = N(1,:);
% part_x = 0.88;pinned_nodes = [];
% for i = 1:length(Nx)
%     if Nx(i)<part_x
%         pinned_nodes = [pinned_nodes i];
%     end
% end
% [index_reflection] = re_index_target_nodes('0021',20,0.8);
% target(pinned_nodes,:) = [];

% target_time_0_u = re_index_target(index_reflection,target_time_0_u);
% target_time_0_u(pinned_nodes,:,:)= [];
% 
% 666
% target_time_u_0 = re_index_target(index_reflection,target_time_u_0);
% target_time_u_0(pinned_nodes,:,:)= [];
% 
% target_time_0_l = re_index_target(index_reflection,target_time_0_l);
% target_time_0_l(pinned_nodes,:,:)= [];
% 
% target_time_l_0 = re_index_target(index_reflection,target_time_l_0);
% target_time_l_0(pinned_nodes,:,:)= [];
% 


% important
% target_re_index_up = compat_3(target_time_0_u,target_time_u_0);
% target_re_index_down = compat_3(target_time_0_l,target_time_l_0);
% target_re_index= compat_3(target_re_index_up,target_re_index_down);

% one period

target_re_index = target_time_0_u;

% target_re_index = compat_3(target_time_0_u,target_time_u_0);
% target_re_index = re_index_target(index_reflection,target_re_index);
% target_re_index(pinned_nodes,:,:)= [];
tenseg_plot_target_3D(N,C_b,C_s,target_re_index(:,:,end));

control_point  = 1:length(N_simple(1,:));
control_point(pinned_nodes) = [];

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

Yt = target_re_index;

[U,Ez,V] = svd(P);
U1 = U(:,1:size(P,2));U2 = U(:,size(P,2)+1:end); E0 = Ez(1:size(P,2),:);
Nd = 0*N;
x0 = [N*U2 , Nd*U2];
dt = 0.01; tf = 30;
warning off
% dt = 0.001; tf = 10;
t = 0:dt:tf;
    a=1.5;
    b=2;
Inp.a=a;Inp.b=b;Inp.Cs = Cs; Inp.Cb=Cb; Inp.W=W; Inp.s0=s0; Inp.b0=b0;Inp.tf=tf;Inp.P=P;Inp.D=D;Inp.B=B;Inp.S=S;Inp.Yt=Yt;Inp.L=L;Inp.R=R;
Inp.t_span = 1;Inp.t_total = 10;Inp.mn = x0;

%%
% y = ode4(@classkcontrol2,t,x0,Inp);
y = ode41(@classkcontrol_ljc_nargin,t,x0,Inp);
classkcontrol_ljc_nargin(t,x0,Inp,'sa')
% size(y)
X1 = D*V*E0^-1;
%%
[g_c,l_c,gammashist,lambdahist] = color_mng();


figure(2)
E=[];ble=zeros(size(Cb,1),size(y,1));
err_x = [];
err_y = [];
err_z = [];
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
    err_temp = cal_err(L*N*R-Yt(:,:,end)');
    E_temp = L*N*R-Yt(:,:,end)';
    err_x = [err_x;E_temp(1,:)];
    err_y = [err_y;E_temp(2,:)];
    err_z = [err_z;E_temp(3,:)];
    E = [E;err_temp];
end

for i =1:length(E(1,:))
%     plot(t/100,E(:,i)),axis([0 20/100 -0.05 0.1]),hold on
plot(t/100,err_z),axis([0 40/100 -0.05 0.1]),hold on
end
xlabel('Time (sec)')
ylabel('Error (m)')
% % tenseg_plot(N,Cb,Cs)

% cartoon(Ntrace,Cb,Cs,['Dolphin_0_up'  int2str(angle_tail) '.avi'],target_re_index(:,:,end));    %cartoon of control

H.N = Ntrace;
H.B = Btrace;
H.S = Strace;
H.RB = RBtrace;
H.RS = RStrace;
H.tf = tf;
H.dt = t;
save dolphin_python_total
end
