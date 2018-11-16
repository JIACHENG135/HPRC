function [NNew]=wheelnotation(NN)
NN=round(NN,4);
N1=NN;
[Npx,Npy,Npz]=cart2pol(N1(1,:),N1(2,:),N1(3,:));
NNew=zeros(3,length(Npy));
for i=1:length(Npx)
    if Npx(i)<0
        Npx(i)=2*pi+Npx(i);
    end
end
Length=Npx/100+Npy+Npz;
len=sort(Length);
for i=1:length(Npx)
    NNew(1,i)=NN(1,find(Length==len(i)));
    NNew(2,i)=NN(2,find(Length==len(i)));
    NNew(3,i)=NN(3,find(Length==len(i)));
end
save test
end