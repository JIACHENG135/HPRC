function [N,C_b,C_s]=main_fish(q,parent,wing_string)
C_b=[];C_s=[];
while q>0
    [N,new_parent,C_b_in,C_s_in,wing_string]=genetbar(parent,wing_string);
    C_b=[C_b;C_b_in];
    C_s=[C_s;C_s_in];
    parent = new_parent;
    q=q-1;
end
Nx = unique(N(1,:));
for i=1:length(Nx)-1
    C_b = [C_b;Nx(i+1) 0 0 N(i) 0 0];
end
temp_p = max(N(find(N(:,1)==0.5),3));
temp_n = min(N(find(N(:,1)==0.5),3));

C_b=[C_b;0.5 0 temp_p 0.5 0 0;0.5 0 temp_n 0.5 0 0];
C_s = [C_s;0.5 0 temp_p 0 0 0;0.5 0 temp_p 1 0 0;...
    0.5 0 temp_n 0 0 0;0.5 0 temp_n 1 0 0];
end