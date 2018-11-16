function hori_N = find_hori_ver_N(N,x)
hori_N = [];
for i=1:length(N(:,1))
    if N(i,1)<x
        hori_N = [hori_N i];
    end
end
end
        