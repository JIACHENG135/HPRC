function plotcbcs
load 'Nodesss.mat'
for i=1:length(C_b_innew(:,1))
    xb=[Nodes(C_b_innew(i,1),1) Nodes(C_b_innew(i,2),1)];
    yb=[Nodes(C_b_innew(i,1),2) Nodes(C_b_innew(i,2),2)];
    plot(xb,yb,'b'),hold on
%     grid on
%     axis equal
end
for i=1:length(C_s_innew(:,1))
    xs=[Nodes(C_s_innew(i,1),1) Nodes(C_s_innew(i,2),1)];
    ys=[Nodes(C_s_innew(i,1),2) Nodes(C_s_innew(i,2),2)];
    plot(xs,ys,'r--'),hold on
    grid on
    axis equal
end

% yb=nodes(C_b_in(:,1),2);
% xs=nodes(C_s_in(:,1),1);
% ys=nodes(C_s_in(:,1),2);
% plot(xb,yb,'b')
% ,xs,ys,'r'
%save cbcs
end