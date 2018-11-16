function plottest(A,B,phi)
plot(A(1),A(2),'g*');hold on
plot(B(1),B(2),'r*');
C=rota(A,B,phi);
plot(C(1),C(2),'B*')
axis equal;
end