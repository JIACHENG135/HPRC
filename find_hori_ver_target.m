function [hori_N,hori_N_up,hori_N_down] = find_hori_ver_target(N,x)
hori_N = [];
hori_N_down=[];
hori_N_up=[];
cor_hori_N = [];
cor_hori_N_down = [];
cor_hori_N_up = [];
for i=1:length(N(:,1))
    if N(i,1)>x&&N(i,3)==0
        hori_N = [hori_N i];
        cor_hori_N = [cor_hori_N N(i,1)];
    end
    if N(i,1)>x&&N(i,3)<0
        hori_N_down = [hori_N_down i];
        cor_hori_N_down = [cor_hori_N_down N(i,1)];
    end
    if N(i,1)>x&&N(i,3)>0
        hori_N_up = [hori_N_up i];
        cor_hori_N_up = [cor_hori_N_up N(i,1)];
    end
end
% hori_target = [hori_N hori_N_down hori_N_up];
[~,index]= sort(cor_hori_N);
hori_N=hori_N(index);
[~, index_down]= sort(cor_hori_N_down);
hori_N_down=hori_N_down(index_down);
[~, index_up]= sort(cor_hori_N_up);
hori_N_up=hori_N_up(index_up);
end
        