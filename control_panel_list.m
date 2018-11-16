function [new_set_rep,P_set] = control_panel_list(ori,size_z,angle_ori,ratio,de_ratio,wing_string,number)
%% generate horizontal points after change 
[C_s_cor_all,C_b_cor_all,Nodes_all,ori,size_z]=connect_tri_double(wing_string,number);
load size
% angle = pi/180*10;
% ratio = 0.8;
points_set = ori(:,[1:2]);

new_set = points_set(find(points_set(:,1)>ratio),[1:2]);
size_z = size_z(find(points_set(:,1)>ratio));
angle = [pi/180:pi/180:angle_ori];
new_set_rep = repmat(new_set,length(angle),1);
angle = angle/(length(new_set(:,1))-1);
angle_r = angle';

re_new = reshape((1:length(new_set_rep(:,1))),length(new_set(:,1)),length(new_set_rep(:,1))/length(new_set(:,1)));
save new_set

for i=1:length(new_set(:,1))-1
    row_temp = re_new(i+1:end,:);
    row_temp = row_temp(:);
    new_set_rep(row_temp,:) = rotanew(new_set(i+1:end,:),new_set(i,:),angle_r);
%     new_set(i+1:end*length(angle),:) = rotanew(new_set(i+1:end,:),new_set(i,:),angle);
end
%%
new_set = [new_set(:,1) zeros(length(new_set(:,1)),1) new_set(:,2)];
new_set_rep = [new_set_rep(:,1) zeros(length(new_set_rep(:,1)),1) new_set_rep(:,2)];

% plot3(new_set(:,1),zeros(size(new_set(:,1))),new_set(:,3),'r*'),axis equal,hold on
% plot(points_set(:,1),points_set(:,2),'bo')
P_set = [];
% save size_set
%% generate triangle out points 
for i=1:length(new_set(:,1))-1
    row_temp_1 = re_new(i,:);
    row_temp_2 = re_new(i+1,:);
%     new_set_rep(row_temp_1,:)
%     new_set_rep(row_temp_2,:)
    [P_temp,P_left_temp,P_right_temp] = gene_triangle_with_2pt_list(new_set_rep(row_temp_1,:),new_set_rep(row_temp_2,:),size_z(i));

    P_set = [P_set;vpa(P_temp);double(P_left_temp);double(P_right_temp)];
end
% P_set = vpa(P_set,4);
P_set = double(P_set);
% new_set_rep = [new_set_rep;P_set];
% plot3(P_set(:,1),P_set(:,2),P_set(:,3),'b*'),axis equal;