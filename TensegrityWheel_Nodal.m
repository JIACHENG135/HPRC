function [N] = TensegrityWheel_Nodal(q,r,R,alpha)

N = zeros(3,12*q);

%Inner Circle
N1 = [r*cos(0);r*sin(0);0];
N2 = [r*cos(pi/2);r*sin(pi/2);0];
N3 = [r*cos(pi);r*sin(pi);0];
N4 = [r*cos(3*pi/2);r*sin(3*pi/2);0];


Rot = [cos(pi/(2*q)) -sin(pi/(2*q)) 0;
     sin(pi/(2*q)) cos(pi/(2*q)) 0;
     0 0 1];

 
for i = 1:1:q
    N(:,1+4*(i-1)) = Rot^(i-1)*N1;
    N(:,2+4*(i-1)) = Rot^(i-1)*N2;
    N(:,3+4*(i-1)) = Rot^(i-1)*N3;
    N(:,4+4*(i-1)) = Rot^(i-1)*N4;
end

%Outer Circle
syms x
eqn1 = (1+tan(alpha)^2)*x^2 - 2*r*tan(alpha)^2*x + r^2*tan(alpha)^2 - R^2 == 0;
x = solve(eqn1,x);
y = sqrt(R^2 - x(1,1)^2);
Rot90 = [0 -1 0;1 0 0;0 0 1];
N1 = [x(1,1);y;0];
N2 = Rot90*N1;
N3 = Rot90*N2;
N4 = Rot90*N3;
N5 = [x(1,1);-y;0];
N6 = Rot90*N5;
N7 = Rot90*N6;
N8 = Rot90*N7;

for i = 1:1:q
    N(:,(4*q+1)+8*(i-1)) = Rot^(i-1)*N1;
    N(:,(4*q+2)+8*(i-1)) = Rot^(i-1)*N2;
    N(:,(4*q+3)+8*(i-1)) = Rot^(i-1)*N3;
    N(:,(4*q+4)+8*(i-1)) = Rot^(i-1)*N4;
    N(:,(4*q+5)+8*(i-1)) = Rot^(i-1)*N5;
    N(:,(4*q+6)+8*(i-1)) = Rot^(i-1)*N6;
    N(:,(4*q+7)+8*(i-1)) = Rot^(i-1)*N7;
    N(:,(4*q+8)+8*(i-1)) = Rot^(i-1)*N8;
end