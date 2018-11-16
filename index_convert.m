function B=index_convert(A,N_new_new_index)
for i=1:length(A)
B(i)=find(N_new_new_index(4,:)==A(i));
end