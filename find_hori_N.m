function hori_N = find_hori_N(N,x)
hori_N = [];
cor_hori_N = [];
for i=1:length(N(:,1))
    if abs(N(i,3))==0&&N(i,1)>x
        hori_N = [hori_N i];
        cor_hori_N = [cor_hori_N N(i,1)];
    end
end
% N_with_index = [hori_N ;cor_hori_N];
[cor_hori_N index]= sort(cor_hori_N);
hori_N=hori_N(index);
end
        