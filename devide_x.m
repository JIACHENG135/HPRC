function [xU,zU,xL,zL] = devide_x(q,wing_string)
iaf.designation=wing_string;
n = 2^q + 1;
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