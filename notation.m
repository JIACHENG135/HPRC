function [Nnew]=notation(NN,phi,q)
NN=round(NN,4);
[a,b,c]=size(NN);
N1=[];
beta=pi/phi;
rho=zeros(q+1,pi/phi);
for i=1:c
    N1=[N1 NN(:,:,i)];
end
N1=unique(N1','rows');
N1=N1';
[Npx,Npy,Npz]=cart2pol(N1(1,:),N1(2,:),N1(3,:));


for i=1:length(Npx)
    if Npx(i)<0
        Npx(i)=2*pi+Npx(i);
    end
end
save x
Np=[Npx;Npy;Npz];
Npyy=Npy;
index=[];
for i=1:q+1
    rho(i,:)=find(abs(Npy-max(Npy))<0.01);
    Npy(rho(i,:))=0;
    tem=Npx(rho(i,:));
    temp=sort(tem(1,:));
    indexx=[];
    for k=1:length(temp)
        indexx=[indexx find(tem==temp(k))];
    end
    index=[index indexx+beta*(i-1)];
end
rhoo=[]
for i=1:length(rho(:,1));
    rhoo=[rhoo rho(i,:)];
end
Nnew=zeros(3,length(N1));
for i=1:length(N1)
     Nnew(:,i)=N1(:,rhoo(index(i)));
end
end