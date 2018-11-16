function index_ori_x=gene_skin(Nodes)
x = Nodes(:,1);
b = sort(x);
index_ori_x={}; 
for i =1:length(b)
    index_ori_x{i,1} = find(x==b(i));
end