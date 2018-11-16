function testN(N)
for i=1:length(N(1,:))
    tempN=N(:,i);
    plot3(tempN(1),tempN(2),tempN(3),'ro')
    axis equal
    hold on
end
end