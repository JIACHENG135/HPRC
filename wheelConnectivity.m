function [C_b_in,C_s_in]=wheelConnectivity(N)
C_b_in=[];
C_s_in=[];
% N=wheelnotation(N);
N=round(N,4);
[a,b]=size(N);
[Npx]=cart2pol(N(1,:),N(2,:),N(3,:));
for i=1:length(N(1,:))*2/3-1
    C_b_in=[C_b_in;length(N(1,:))/3+i length(N(1,:))/3+i+1];
end

C_b_in=[C_b_in;length(N(1,:)) b/3+1];
for i=1:length(N(1,:))/3
    if rem(i+1,length(N(1,:))/3)
        C_b_in=[C_b_in;i rem(i+1,length(N(1,:))/3);];
    else
        C_b_in=[C_b_in;i length(N(1,:))/3];
    end
end
% for i=1:length(N(1,:))/3
%     if rem(i+1,length(N(1,:))/3)
%         C_s_in=[C_s_in;i rem(i+1,length(N(1,:))/3);];
%     else
%         C_s_in=[C_s_in;i length(N(1,:))/3];
%     end
% end
temv=[];
% temv is the temp vector
for i=b/3+1:2/3*b+1
    if rem(i,2)
        i
        tempN=i+b/3-1;
    else
        i
        tempN=i+b/3+1;
        if tempN-b-1
            tempN=i+b/3+1;
        else
            tempN=b/3+1;
        end
    end
    inter1=find(abs(N(1,:)-1/2*(N(1,i)+N(1,tempN)))<0.0001);
    inter2=find(abs(N(2,:)-1/2*(N(2,i)+N(2,tempN)))<0.0001);
    C_s_inter=intersect(inter1,inter2)
    C_s_in=[C_s_in;C_s_inter,i;C_s_inter,tempN]
end