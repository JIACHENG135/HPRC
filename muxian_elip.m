function [b,y1] = muxian_elip(N,a,x1)
maxy=find(N(:,2)==max(N(:,2)));
y = max(N(:,2));
x = N(maxy,1);
x_max = max(x);
b = sqrt(a^2*y^2/(a^2-x_max^2));
y1=sqrt(b^2-b^2*x1^2/a^2);
end