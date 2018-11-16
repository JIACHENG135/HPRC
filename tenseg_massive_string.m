function ms=tenseg_massive_string(s_0,N_new,C_s_new,string_nodes_index,A_string)
Mass_s_0=s_0.*A_string;
nodes_mass=zeros(length(N_new(1,:)),2);
nodes_mass(:,1)=[1:length(N_new(1,:))]';
for i=1:length(s_0)
    pointa=find(C_s_new(i,:)==-1);
    pointb=find(C_s_new(i,:)==1);
    nodes_mass(pointa,2)=nodes_mass(pointa,2)+Mass_s_0(i)/2;
    nodes_mass(pointb,2)=nodes_mass(pointb,2)+Mass_s_0(i)/2;
end
ms=nodes_mass(string_nodes_index,2);
end