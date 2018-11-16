function [N,new_parent,C_b_in,C_s_in,str_wing]=genetbar(parent,str_wing)
iaf.designation=str_wing;
iaf.n=100;
iaf.HalfCosineSpacing=1;
iaf.wantFile=1;
iaf.datFilePath='./'; % Current folder
iaf.is_finiteTE=0;
af = naca4gen(iaf);
xU=af.xU;
xU=xU(end:-1:1);
zU=af.zU;
zU=zU(end:-1:1);
xL=af.xL;
zL=af.zL;

xxU=xU';
xxL=xL';
zzU=zU';
zzL=zL';
sdU = [af.xU;af.zU];%sdU=sample_dataU
sdL = [af.xL;af.zL];
C_b_in=[];
C_s_in=[];
new_cor=[];
new_parent = zeros(2*length(parent(:,1)),2);
for i=1:length(parent(:,1))
    new_cor(i) = (parent(i,1) + parent(i,2))/2;
    new_parent(2*(i-1)+1:2*i,:) =[parent(i,1),new_cor(i);new_cor(i) parent(i,2)];
    Nx(i,:)=[parent(i,1) new_cor(i) parent(i,2)];% It will cost a lot of more time anyway I don't want to optimize it
    x1ud = merge_cr(xU,Nx(i,:));
    x1ld = merge_cr(xL,Nx(i,:));
    Nzu(i,:)=(Nx(i,:)-xxU(x1ud))./(xxU(x1ud+ones(size(x1ud)))-xxU(x1ud)).*(zzU(x1ud+ones(size(x1ud)))-zzU(x1ud))+zzU(x1ud);
    Nzl(i,:)=(Nx(i,:)-xxL(x1ld))./(xxL(x1ld+ones(size(x1ud)))-xxL(x1ld)).*(zzL(x1ld+ones(size(x1ud)))-zzL(x1ld))+zzL(x1ld);
%     C_s_in = [C_s_in;Nx(i,2) Nzu(i,2) Nx(i,1) Nzu(i,1);Nx(i,2) Nzl(i,2) Nx(i,1) Nzl(i,1);...
%         Nx(i,2) Nzu(i,2) Nx(i,3) Nzu(i,3);Nx(i,2) Nzl(i,2) Nx(i,3) Nzl(i,3)];
%     C_b_in = [C_b_in;Nx(i,2) Nzu(i,2) Nx(2,1) 0;Nx(i,2) Nzl(i,2) Nx(i,2) 0;...
%         Nx(i,1) Nzl(i,1) Nx(i,2) 0;Nx(i,3) Nzl(i,3) Nx(i,2) 0];
end
for i=1:length(Nx(:,1))
        C_s_in = [C_s_in;Nx(i,2) 0 Nzu(i,2) Nx(i,1) 0 0;Nx(i,2) 0 Nzl(i,2) Nx(i,1) 0 0;...
        Nx(i,2) 0 Nzu(i,2) Nx(i,3) 0 0;Nx(i,2) 0 Nzl(i,2) Nx(i,3) 0 0];
        C_b_in = [C_b_in;Nx(i,2) 0 Nzu(i,2) Nx(i,2) 0 0;Nx(i,2) 0 Nzl(i,2) Nx(i,2) 0 0;...
        Nx(i,1) 0 0 Nx(i,2) 0 0;Nx(i,3) 0 0 Nx(i,2) 0 0];
end
Ny = zeros(size(Nx(:)));
Nu=[Nx(:) Ny Nzu(:)];
Nl=[Nx(:) Ny Nzl(:)];
N_plus = [unique(Nx(:)) zeros(size(unique(Nx(:)))) zeros(size(unique(Nx(:))))];
N=[Nu;Nl;N_plus];
N=round(N,10);
C_b_in = round(C_b_in,10);
C_s_in = round(C_s_in,10);
N = setoff_dup(N);