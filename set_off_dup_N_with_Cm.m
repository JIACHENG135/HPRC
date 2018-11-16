function [N,C_b_in,C_s_in] = set_off_dup_N_with_Cm(N,C_b_in,C_s_in)
sumN = sum(N,2);
diffe = [];
pl = nchoosek([1:length(N(:,1))],2);
for i=1:length(pl(:,1))
    diffe = [diffe;abs(sumN(pl(i,1))-sumN(pl(i,2)))];
end
%% find out the duplicated one Nodes and set them to on pints
%     change the corresponding number in the connective matrix
%     and some number in Cn should be more smaller

pl_temp =pl(find(diffe == 0),:);
pl_temp2 = pl(find(diffe == 0),:);
pl_temp = sort(unique(pl_temp(:)));
unchange = min(pl_temp);
pl_temp(1) = [];
N(pl_temp,:) = [];

for i =1:length(pl_temp)
C_b_in(find(C_b_in==pl_temp(i))) = unchange;
C_s_in(find(C_s_in==pl_temp(i))) = unchange;

end
for i = 1:length(pl_temp) -1 
    C_b_in(find(C_b_in>pl_temp(i) & C_b_in<pl_temp(i+1))) ...
    = C_b_in(find(C_b_in>pl_temp(i) & C_b_in<pl_temp(i+1))) - 1;
C_s_in(find(C_s_in>pl_temp(i) & C_s_in<pl_temp(i+1))) ...
    = C_s_in(find(C_s_in>pl_temp(i) & C_s_in<pl_temp(i+1))) - 1;
end
i = i+1;
C_b_in(find(C_b_in>pl_temp(i)) )= C_b_in(find(C_b_in>pl_temp(i))) - length(pl_temp);
C_s_in(find(C_s_in>pl_temp(i)) )= C_s_in(find(C_s_in>pl_temp(i))) - length(pl_temp);

% need to prove


