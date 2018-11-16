function B=guiyihua(A)
[a,b]=size(A);
B=zeros(a,b);
for i=1:a
    for j=1:b   
        B(i,j) = A(i,j)/max(A(:));
    end
end
end