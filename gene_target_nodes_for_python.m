function [New_target_0_u,C_b,C_s,C_b_in,C_s_in,file_name]=gene_target_nodes_for_python(td,tf,theta,number,wing_string,ratio,file_name)
[index_reflection] = re_index_target_nodes(wing_string,number,ratio);
[Nodes_all,C_b,C_s,C_b_in,C_s_in,target_ori] = dolphin_target_generator(wing_string,pi/180,number,ratio);

[Nodes_all_fore,C_b_fore,C_s_fore,C_b_in_fore,C_s_in_fore,~] = dolphin_target_generator_fore(wing_string,0,number,0);
[Nx,~,~,~,~] = dolphin_target_generator(wing_string,0,number,ratio);
Nx = setoff_dup(Nx)'; 
Nx = Nx(1,:);
part_x = 0.88;pinned_nodes = [];
for i = 1:length(Nx)
    if Nx(i)<part_x
        pinned_nodes = [pinned_nodes i];
    end
end
tn = tf/td;
theta_t = theta / tn;
[a,b] = size(target_ori);
target_time_0_u = zeros(a,b,tn);
target_time_u_0 = zeros(a,b,tn);
target_time_0_l = zeros(a,b,tn);
target_time_l_0 = zeros(a,b,tn);                                                                                                                           
save pythontest
for i = 1:tn
%     wing_string,theta_t*i,number,ratio
    [~,~,~,~,~,target_time_0_u(:,:,i)] = dolphin_target_generator(wing_string,theta_t*i,number,ratio);
    [~,~,~,~,~,target_time_u_0(:,:,i)] = dolphin_target_generator(wing_string,theta_t*(tn-i+1),number,ratio);
    [~,~,~,~,~,target_time_0_l(:,:,i)] = dolphin_target_generator(wing_string,-theta_t*i,number,ratio);
    [~,~,~,~,~,target_time_l_0(:,:,i)] = dolphin_target_generator(wing_string,-theta_t*(tn-i+1),number,ratio);
end
% [a,b,c] = size(target_time_0_u);
% New_target = zeros(a,b,c*4*Period);
file_name = [file_name 'td' mat2str(td) 'tf' mat2str(tf) 'theta' mat2str(theta) 'number' mat2str(number)  wing_string 'ratio' mat2str(ratio) '.mat'];







New_target_0_u = plot_target_cn(index_reflection,target_time_0_u);
New_target_u_0 = plot_target_cn(index_reflection,target_time_u_0);
New_target_0_l = plot_target_cn(index_reflection,target_time_0_l);
New_target_l_0 = plot_target_cn(index_reflection,target_time_l_0);
target_time_0_u = re_index_target(index_reflection,target_time_0_u);
target_time_0_u(pinned_nodes,:,:)= [];

target_time_0_l = re_index_target(index_reflection,target_time_0_l);
target_time_0_l(pinned_nodes,:,:)= [];

target_time_u_0 = re_index_target(index_reflection,target_time_u_0);
target_time_u_0(pinned_nodes,:,:)= [];

target_time_l_0 = re_index_target(index_reflection,target_time_l_0);
target_time_l_0(pinned_nodes,:,:)= [];
save(file_name)
save(['d:\history\' file_name])
end
