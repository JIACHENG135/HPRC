function j=merge_cr(A,target)
for i=1:length(target)
    j(i)=length(A);
while target(i)<A(j(i))
    j(i) = j(i)-1;
end                          
if j(i)==length(A)
    j(i) = j(i) -1;
end
end
end