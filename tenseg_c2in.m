function C_b_in = tenseg_c2in(C_b)
[a,~]=size(C_b);
% C_b_in=[a,2];
for i=1:a
 C_b_in(i,1)= find(C_b(i,:) == -1);
 C_b_in(i,2)=find(C_b(i,:) == 1);
end
end
