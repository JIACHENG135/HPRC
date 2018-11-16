function n4=rota(p,n,phi)
n4=zeros(2,1);
% n4(1)=(x(1)-rx(1))*cos(phi)-(x(2)-rx(2))*sin(phi)+rx(1);
% n4(2)=(x(1)-rx(1))*sin(phi)+(x(1)-rx(1))*cos(phi)+rx(2);

theta=atan((p(2)-n(2))/(p(1)-n(1)));
l=sign(p(1)-n(1))*eulerdst(p,n);
b=cos(pi-(phi+theta));
a=sin(phi+theta);
n4(1)=n(1)+l*cos(phi+theta);
n4(2)=n(2)+l*sin(phi+theta);
end
