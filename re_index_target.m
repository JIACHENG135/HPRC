function target_new = re_index_target(index_reflection,target)
% target = R n*3 or R n*3*time_span
target_test = target(:,:,1);
if length(target(:)) == length(target_test(:))
    target_new = zeros(max(index_reflection),3);
    for i =1:max(index_reflection)
        index_temp = find(index_reflection == i);
        if length(index_temp)>1
            index_temp_max = find(target(index_temp,1) == max(target(:,1)));
            index_temp = index_temp(index_temp_max);

        end
        target_new(i,:) = target(index_temp,:);

    end
else
    [~,~,c] = size(target);
    target_new = zeros(max(index_reflection),3,c);
    for j = 1:c
        for i =1:max(index_reflection)
        index_temp = find(index_reflection == i);
        if length(index_temp)>1
            index_temp_max = find(target(index_temp,1,j) == max(target(:,1,j)));
            index_temp = index_temp(index_temp_max);

        end
        target_new(i,:,j) = target(index_temp,:,j);

        end
    end
end