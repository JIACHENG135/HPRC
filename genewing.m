% function [Nu,Nl,C_b_in,C_s_in]=genewing(str_wing,N,angle_dbar,q_dbar)
function [full_datau,N_wingu,N_wingl,Nu,Nl,C_b_in,C_s_in]=genewing(str_wing,N,angle_dbar,q_dbar)
[y,Nn,C_b_in,C_s_in]=main(N,angle_dbar,q_dbar);
Ny=Nn(:,1)'-N(1)/2;
Nx=Nn(:,2)';
Nz=Nn(:,3);
Nn=[Ny' Nx' Nz];
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
sdU = [af.xU;af.zU];%sdU=sample_dataU
sdL = [af.xL;af.zL];%sdL=sample_dataL
Nzu = zeros(size(Nx));
Nzl = zeros(size(Nx));
full_datau = cell(length(Ny),2);
full_datal = cell(length(Ny),2);
N_wing = cell(length(Ny),1);
for i=1:length(Ny)
    [b,propotion(i)] = muxian_elip(Nn,2,Ny(i));
%     propotion(i) = (Ny(i)+2/9)/(2/9+2)*0.5;
    full_datau{i,2} = [xU.*2.*propotion(i)-propotion(i) zU.*2.*propotion(i)];
    full_datal{i,2} = [xL.*2.*propotion(i)-propotion(i) zL.*2.*propotion(i)];
%     middle_point_distance = (full_data{2,i}(1,1)+full_data{2,i}(1,end))/2;
%     full_data{2,i}(1,:) = full_data{2,i}(1,:) + middle_point_distance;
    full_datau{i,1} = Ny(i);
    full_datal{i,1} = Ny(i);
    x1ud = merge_cr(xU.*2.*propotion(i)-propotion(i) ,Nx(i));
    x1ld = merge_cr(xL.*2.*propotion(i)-propotion(i),Nx(i));
    xxU=xU.*2.*propotion(i)-propotion(i);
    xxL=xL.*2.*propotion(i)-propotion(i);
    zzU=zU.*2.*propotion(i);
    zzL=zL.*2.*propotion(i);
%     if x1ld>=length(xL)
%         x1ld = x1ld-1;
%     end
%     if x1ud>=length(xU)
%         x1ud = x1ud-1;
%     end    
    Nzu(i)=(Nx(i)-xxU(x1ud))/(xxU(x1ud+1)-xxU(x1ud))*(zzU(x1ud+1)-zzU(x1ud))+zzU(x1ud);
    Nzl(i)=(Nx(i)-xxL(x1ld))/(xxL(x1ld+1)-xxL(x1ld))*(zzL(x1ld+1)-zzL(x1ld))+zzL(x1ld);
    N_wingu{i,1} = [Ny(i)*ones(size(full_datau{i,2}(:,1))) full_datau{i,2}];
    N_wingl{i,1} = [Ny(i)*ones(size(full_datal{i,2}(:,1))) full_datal{i,2}];

end
Nu=[Nx;Ny;Nzu];
Nl=[Nx;Ny;Nzl];
end