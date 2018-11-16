function [P_new,N_new_new,char_value_old,char_value_new,N_new_new_index]=tenseg_class_k_countP(N_new,P)
P2=P(:,find(sum(P)~=0,1):end);
P1=P(:,1:find(sum(P)~=0,1)-1);
char_value_old=car2sph_ljc(N_new');
P2_new=zeros(size(P2));

pinned_node=zeros(1,length(P2(1,:)));
for i=1:length(P2(1,:))
    pinned_nodes(i)=find(P2(:,i)~=0);
end
pinned_nodes=unique(pinned_nodes);
N_new_new_index = tenseg_class_k_convert_N_simple_pin(N_new,pinned_nodes);
N_new_new = N_new_new_index(1:3,:);
char_value_new=car2sph_ljc(N_new_new');
for i=1:length(P2(1,:))
    P2_new(i,i)=1;
end
P1_new=zeros(size(P1));
a = zeros(2,length(P1_new(1,:)));
a_new = zeros(2,length(P1_new(1,:)));
for i=1:length(P1_new(1,:))
    a(1,i)=find(P1(:,i)==1);
    a(2,i)=find(P1(:,i)==-1);
    index = find(char_value_new == char_value_old(a(1,i)));
    a_new(1,i) = index(1);
%     find(char_value_new == char_value_old(a(2,i)));
    a_new(2,i) = index(2);
%     find(char_value_new == char_value_old(a(2,i)),1);
%     a_new(:,i) = unique(a_new(:,i));
end
a_new_new = zeros(size(a_new));
row1 = unique(a_new(1,:));
for i=1:length(row1)
    a_new_new(:,i) = a_new(:,find(a_new(1,:)==row1(i)));
end
for i=1:length(P1_new(1,:))
    P1_new(a_new_new(1,i),i)=1;
    P1_new(a_new_new(2,i),i)=-1;
end
P_new = [P1_new P2_new];
end