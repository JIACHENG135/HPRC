function [C_s_in,C_b_in] = set_off_dup_C(C_s_in,C_b_in)
%% drop duplicated C_s_in and C_b_in, keep C_b_in instead
drop_C_s = [];
for i = 1:length(C_s_in(:,1))
    if ismember(C_s_in(i,:),C_b_in,'rows')
        drop_C_s = [drop_C_s; i];
    end
end
C_s_in(drop_C_s,:) = [];
