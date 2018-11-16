function N = setoff_dup(N)
[a,b,c]=cart2pol(N(:,1),N(:,2),N(:,3));
chara = 1*a + 3* b +17*c;
chara_u = unique(chara);
index = [];
for i=1:length(chara_u)
    temp_index = find(chara==chara_u(i));
    index = [index;temp_index(1)];
end
N = N(index,:);
end