function [P,P_left,P_right]=gene_triangle_with_2pt_list(A,B,size)
% this script is used for generate triangle which is vertical to the line
% between these two points
% Given A in the plane
% A and B row in
%%
nmal_vec = A - B;
% unit_nmal_vec = nmal_vec /(sqrt(abs(nmal_vec*nmal_vec')));
y=0;
syms x 
syms z 
equal_1=nmal_vec(:,1).*(x-A(:,1))+nmal_vec(:,2).*(y-A(:,2))...
    +nmal_vec(:,3).*(z-A(:,3));
equal_2 = (x-A(:,1)).^2 + (y-A(:,2)).^2+(z-A(:,3)).^2;

%%
P = [];
P_left = [];
P_right = [];
for i =1:length(equal_1(:,1))
    [x0,z0]=solve(equal_1(i,:)==0,equal_2(i,:)==size^2,x,z);
    x0(find(z0~=max(z0)) )= [];
    z0(find(z0~=max(z0)) ) = [];
% if z0(1)<0
%     P = [x0(2) 0 z0(2)];
% else
%     P = [x0(1) 0 z0(1)];
% end
    P_temp = [x0 0 z0];
    P_temp = double(vpa(P_temp));
    P = [P;P_temp];

% A_nor = unit_nmal_vec;
% Ax = A_nor(1);Px = P(1);
% Ay = A_nor(2);Py = P(2);
% Az = A_nor(3);Pz = P(3);
% theta = pi*120/180;
% theta_2 = theta*2;
% axp = [Ay*Pz - Az*Py,Az*Px - Ax*Pz,Ax*Py - Ay*Px];
% P_left= vpa(P*cos(theta) + (axp)*sin(theta) + A*(A*P')*(1 - cos(theta)),10);
% P_right = vpa(P*cos(theta_2) + (axp)*sin(theta_2) + A*(A*P')*(1 - cos(theta_2)),10);
%%
% P_left_test = rotanew_point_axis(P,A_nor,pi/180*120);
% dbstop if error

    P_left_temp = trans_space_to_rota(P_temp,A(i,:),B(i,:),pi/180*120);
    P_left = [P_left;double(P_left_temp')];
% Don't need list. Just 2

% trans_space_to_rota(A,P1,P2,theta)
    P_right_temp = trans_space_to_rota(P_temp,A(i,:),B(i,:),pi/180*240);
    P_right = [P_right;double(P_right_temp')];
% 
end
%     points = vpa([A;B;P;P_left_test';P_right_test']);
% points
% save point
% plot3(points(:,1),points(:,2),points(:,3),'r*'),axis equal;
