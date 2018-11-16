function [xU,zU,xL,zL] = devide_x_n(wing_string,n)
iaf.designation=wing_string;
iaf.n=n;
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
end