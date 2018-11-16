function [N,C_b_in,C_s_in]=main_fish_uneven(q,wing_string)
[xU_nx,zU,xL,zL] = devide_x(q,wing_string);
[xU,zU,xL,zL] = devide_x_n(wing_string,200);
index=gene_parent(xU,q);
Nzu=[];
Nzl=[];
Nxx=[];
C_b_in=[];
C_s_in=[];
xU_nx= xU_nx';
xU = xU';
zU= zU';
xL=xL';
zL=zL';
for i=1:q
    Nx = xU_nx(index{i,1});
    if i==1
        sum_len=0;
    else
        sum_len=sum_len+length(index{i-1,1});
    end
    x1ud = merge_cr(xU,Nx);
    x1ld = merge_cr(xL,Nx);
    Nxx=[Nxx Nx];
%     xU(x1ud+ones(size(x1ud)))
    Nzu=[Nzu ((Nx-xU(x1ud))./(xU(x1ud+ones(size(x1ud)))-xU(x1ud)).*(zU(x1ud+ones(size(x1ud)))-zU(x1ud))+zU(x1ud))];
    Nzl=[Nzl ((Nx-xL(x1ld))./(xL(x1ld+ones(size(x1ud)))-xL(x1ld)).*(zL(x1ld+ones(size(x1ud)))-zL(x1ld))+zL(x1ld))];
    for j=1:length(Nx)
        if rem(j,2)==0
            C_b_in = [C_b_in;Nx(j) 0 Nzu(sum_len+j) Nx(j) 0 0;Nx(j) 0 Nzl(sum_len+j) Nx(j) 0 0];
            C_s_in = [C_s_in;Nx(j) 0 Nzu(sum_len+j) Nx(j-1) 0 0;...
                                     Nx(j) 0 Nzu(sum_len+j) Nx(j+1) 0 0;...
                                     Nx(j) 0 Nzl(sum_len+j) Nx(j-1) 0 0;...
                                     Nx(j) 0 Nzl(sum_len+j) Nx(j+1) 0 0];
        end
    end
%     save C_b_in
    if i==q
        for j=1:length(Nx)
            if rem(j,2)==0
                C_b_in = [C_b_in;Nx(j) 0 0 Nx(j+1) 0 0;Nx(j) 0 0 Nx(j-1) 0 0];
            end
        end
    end
end
Ny=zeros(size(Nxx));
N = [Nxx Nxx;Ny Ny;Nzu Nzl]';
N_plus = [unique(Nxx(:)) zeros(size(unique(Nxx(:)))) zeros(size(unique(Nxx(:))))];
N=[N;N_plus];
N=round(N,10);
C_b_in = round(C_b_in,10);
C_s_in = round(C_s_in,10);
N = setoff_dup(N);
end