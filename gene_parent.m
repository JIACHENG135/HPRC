function index=gene_parent(xU,q)
parent = [xU(1) xU(end)];
index = cell(q,1);
temp=[];
q_c = q+1;
while q>0
    j = 2^(q_c-q);
    while j>-1
        temp = [temp 1+j*2^(q-1)];
        j = j-1;
    end
    index{q_c-q,1}=temp;
    temp=[];
    q = q-1;
end
    