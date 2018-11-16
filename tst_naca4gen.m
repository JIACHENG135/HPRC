iaf.designation='2144';
% designation='0008';
iaf.n=200;
iaf.HalfCosineSpacing=1;
iaf.wantFile=1;
iaf.datFilePath='./'; % Current folder
iaf.is_finiteTE=0;

af = naca4gen(iaf);

% plot(af.x,af.z,'bo-')

plot(af.xU,af.zU,'bo-','MarkerSize',2)
hold on
plot(af.xL,af.zL,'ro-','MarkerSize',2)

axis equal
