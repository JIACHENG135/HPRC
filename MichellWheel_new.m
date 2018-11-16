function [N,phi,q,C_s_in,C_b_in]=MichellWheel_new(r0,R,q,phi)
qq=(R/r0)^(1/q);
temp=[];C_s_in=[];


temM=[];
temp=[r0 0];
for i=1:2*pi/phi
    temM=[temM;rotanew(temp,[0 0],phi*i)];
end
% temM is first loop points
New_nodes=cell(q+1,1);
N=[];
for i=1:q+1
    r(i)=r0*(qq^(i-1));
    temN=temM.*(qq^(i-1));
    New_nodes{i}=round(temN,4);
    N=[N;temN];
%     temp=[temp;r(i) 0];
end
% temp=[];
Dis=zeros(1,q);
for i=1:q
    Dis(i)=(r(i)^2+r(i+1)^2-2*cos(phi)*r(i)*r(i+1))^(1/2);
end
N=round(N,4);
Dis=round(Dis,4);
% New_nodes=round(New_nodes);
[theta,r]=cart2pol(N(:,1),N(:,2));
len=theta+r;
for j=2:q+1
    for i=1:2*pi/phi
        for k=1:2*pi/phi
            if abs(eulerdst(New_nodes{j-1,1}(i,:),New_nodes{j,1}(k,:))-Dis(j-1))<0.001
%                 euler(i,k,j)=eulerdst(New_nodes{j-1,1}(i,:),New_nodes{j,1}(k,:))-Dis(j-1);
                [theta1,r1]=cart2pol(New_nodes{j-1,1}(i,1),New_nodes{j-1,1}(i,2));
                len1=theta1+r1;
                start=find(abs(len-len1)==0);
                [theta2,r2]=cart2pol(New_nodes{j,1}(k,1),New_nodes{j,1}(k,2));
                len2=theta2+r2;
                endp=find(abs(len-len2)==0);
                C_s_in=[C_s_in;start endp];
%                 C_s_in=[C_s_in;New_nodes{j-1,1}(i,:) New_nodes{j,1}(k,:)];
            end
        end
    end
end
C_b_in=[];
for i=1:length(New_nodes{1})-1
    C_b_in=[C_b_in;i i+1];
end
C_b_in=[C_b_in;length(New_nodes{1}) 1];
for i=1:length(New_nodes{j})-1
    C_b_in=[C_b_in;length(N)-(i-1) length(N)-i];
end
C_b_in=[C_b_in;length(N)-length(New_nodes{j})+1 length(N)];

save test
