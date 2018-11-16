function [Nodes,C_b_in,C_s_in]=beamMaster(bar_length,interval,q)
indexN = (1:2*q);
indexN(1)=indexN(1)-1;
y=(bar_length-interval)/2;
indexN(end)=indexN(end)+1;
C_b_in=zeros(q,2);
for i =1:q
    C_b_in(i,:)=[2*(i-1) 2*(i-1)+3];
end
temp=C_b_in(:);
temp(find(temp==0))=1;
temp(find(temp==2*q+1))=2*q;
C_b_in=reshape(temp,[q,2]);
indexNtem=[0:2*q+1];
C_s_in=zeros(3*q+1,2);
for i=1:2*q
    C_s_in(i,:)=[i-1 i+1];
end
for i=2*q+1:3*q+1
%     if (i-2*q)*(i-2*q+1)==0
%         C_s_in(i,:)=[inf inf];
%     elseif i-2*q==2*q||i-2*q+1==2*q
%         C_s_in(i,:)=[inf inf];
%     end
        C_s_in(i,:)=[2*(i-2*q-1) 2*(i-2*q-1)+1];
end
temp1=C_s_in(:,1);
C_s_in(find(temp1==1),:)=[];
temp1=C_s_in(:,1);
C_s_in(find(temp1==2*q),:)=[];
temp2=C_s_in(:,2);
C_s_in(find(temp2==1),:)=[];
temp2=C_s_in(:,2);
C_s_in(find(temp2==2*q),:)=[];
% temp2=C_s_in(:,2);
% C_s_in(find(temp2==1),:)=[];
% C_s_in(find(temp2==12),:)=[];
[a,b]=size(C_s_in);
temp=C_s_in(:);
% temp(find(temp==inf))=[];
temp(find(temp==0))=1;
temp(find(temp==2*q+1))=2*q;
C_s_in=reshape(temp,[a,b]);
start_nodes=[0:2:2*(q-1)];
end_nodes=start_nodes + 3;
len=length(start_nodes);
Nodes=zeros(3,len+1);
for i=1:q
    endn= start_nodes(i)+3;
    if start_nodes(i)==0
        start_nodes(i)=1;
        
    elseif start_nodes(i)==2*q+1
        start_nodes(i)=2*q;
    end
    Nodes(1,start_nodes(i))=(bar_length-y)*(i-1);
    Nodes(1,endn)=(bar_length-y)*(i-1)+bar_length;
end
Nodes(1,2*q)=Nodes(1,end);
Nodes(:,end)=[];