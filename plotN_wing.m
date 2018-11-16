function plotN_wing(N_wing)
for i=1:length(N_wing)
    plot3(N_wing{i,1}(:,1),N_wing{i,1}(:,2),N_wing{i,1}(:,3),'b.','MarkerSize',1);
    axis equal
    hold on
end
end