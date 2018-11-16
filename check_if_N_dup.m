function N = check_if_N_dup(N,C_b,C_s)
% in order to eliminate some Nodes that are ...
%not being used but generated
%like some node in the first horizontal points
% N = N';
C_b = [C_b(:,1:3);C_b(:,4:6)];
C_s = [C_s(:,1:3);C_s(:,4:6)];
C = [C_b;C_s];
save test
blank_row = [];
for i = 1:length(N(:,1))
    if ~ismember(N(i,:),C,'rows')
        blank_row = [blank_row i];
    end
end
N(blank_row,:)=[];
% N = N';
end