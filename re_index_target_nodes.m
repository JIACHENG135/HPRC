function [index_reflection] = re_index_target_nodes(wing_string,number,ratio,target_give)
switch nargin
    case 3
        [Nodes_ori,~,~,~,~,target] = dolphin_target_generator(wing_string,pi/180,number,ratio);
    case 4
        [Nodes_ori,~,~,~,~,~] = dolphin_target_generator(wing_string,pi/180,number,ratio);
        target = target_give;
end
target_new = zeros(size(Nodes_ori));
index_reflection =[];
for i=1:length(target(:,1))
    target_temp = zeros(size(Nodes_ori));
    target_temp(:,1) = ones(size(Nodes_ori(:,1)))*target(i,1);
    target_temp(:,2) = ones(size(Nodes_ori(:,1)))*target(i,2);
    target_temp(:,3) = ones(size(Nodes_ori(:,1)))*target(i,3);
    diff_matrix = (target_temp - Nodes_ori);
    sum_diff = (diff_matrix(:,1).^2 + diff_matrix(:,2).^2 +diff_matrix(:,3).^2 ).^(1/2);
    index_reflection = [index_reflection find(sum_diff==min(sum_diff))];
%     target_new(find(sum_diff==min(sum_diff)),:) = target(i,:);
end