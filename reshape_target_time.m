function target_time = reshape_target_time(set_rep,target_set,time_span,nodes_number)
% target_all = target_set(:);
target_time = zeros(nodes_number,3,time_span);
indexx = reshape(1:length(target_set(:,1)),time_span,length(target_set(:,1))/(time_span));
% indexx_line = reshape(1:length(set_rep(:,1)),length(set_rep(:,1))/time_span,time_span);

for i =1:time_span
%     a = indexx(3*(i-1)+1:3*(i-1)+3,:)
%     b = indexx_line(length(set_rep(:,1))/time_span)
    target_time_line_temp = set_rep(1+length(set_rep(:,1))/time_span*(i-1)...
        :length(set_rep(:,1))/time_span+length(set_rep(:,1))/time_span*(i-1),:);
    target_time_temp = target_set(indexx(i,:),:);
	target_time (:,:,i) = [target_time_temp;target_time_line_temp];
end

