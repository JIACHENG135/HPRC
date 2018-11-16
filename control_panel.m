function [new_set,P_set] = control_panel(ori,size_z,angle,ratio,de_ratio)
%% generate horizontal points after change 

points_set = ori(:,[1:2]);
new_set = points_set(find(points_set(:,1)>ratio),[1:2]);

size_z = size_z(find(points_set(:,1)>ratio));
angle = angle/(length(new_set(:,1))-1);
for i=1:length(new_set)-1
    new_set(i+1:end,:) = rotanew(new_set(i+1:end,:),new_set(i,:),angle);
end
new_set = [new_set(:,1) zeros(length(new_set(:,1)),1) new_set(:,2)];
% plot3(new_set(:,1),zeros(size(new_set(:,1))),new_set(:,3),'r*'),axis equal,hold on
% plot(points_set(:,1),points_set(:,2),'bo')
P_set = [];
% save size_set
%% generate triangle out points 
for i=1:length(new_set(:,1))-1
    [P_temp,P_left_temp,P_right_temp] = gene_triangle_with_2pt(new_set(i,:),new_set(i+1,:),size_z(i));
    
    P_set = [P_set;vpa(P_temp);vpa(P_left_temp');vpa(P_right_temp')];
end
% P_set = vpa(P_set,4);
P_set = double(P_set);
% new_set = [new_set;P_set];
% plot3(P_set(:,1),P_set(:,2),P_set(:,3),'b*'),axis equal;