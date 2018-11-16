function New_target = plot_target_cn(index_reflection,target_set)

if length(target_set(:))==length(target_set(:,:))
% index_reflection= re_index_target_nodes(wing_string,number);

    New_target = zeros(length(index_reflection),3);
    for i=1:length(index_reflection)
        New_target(index_reflection(i),:) = target_set(i,:);
    end
else

    New_target = zeros(size(target_set));
    for i=1:length(index_reflection)
        New_target(index_reflection(i),:,:) = target_set(i,:,:);
    end
end
% tenseg_plot_ljc(New_target',C_b,C_s)