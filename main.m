function [y,Nodes,C_b_innew,C_s_innew]=main(N,phi,q)
% p is the last generation's coordinates
% y is the unique points
%% function genedbar() 
%  it can use N which are the initial points' coordinates 
%  and phi which is the principal angle of Dbar to generate nodes,Cb and Cs
%  to of q-complexity Dbar.

%%
% Nodes is important because all C_b_in and C_s_in is originate from their 
% indices.I use round function to remove the numerical err caused by
% Matlab.
% To get the new C_b_in and C_s_in after reshaping the nodes' indices, we
% first save every bar-nodes and string-nodes' coordinates rather than the 
% old indices as we former used. Then by using these coordinates we can get
% the newest indices of C_b_in and C_s_in.
% 
% 
%%
setGlobal(q);
global C_s_in
[y,Nn,C_b_in]=genedbar(N,phi,q);hold off;
while q~=1
    [y,Nn,C_b_in]=genedbar(y,phi,q);hold off;
    q = q-1;
end
C_s_innew=[];C_b_innew=[];Nn=round(Nn,4);
C_s_inround=C_s_in;C_b_inround=C_b_in;
C_s_inround=round(C_s_inround,4);C_b_inround=round(C_b_inround,4);
Nodes=unique(Nn(:,1:3),'rows');
ls=length(C_s_in(:,1));lb=length(C_b_in(:,1));
ins=zeros(ls,1);%C_s_in's start nodes number
outs=zeros(ls,1);%C_s_in's end nodes number
inb=zeros(lb,1);%C_s_in's start nodes number
outb=zeros(lb,1);%C_s_in's end nodes number
for i=1:ls%I want to substitude C_s_in with C_s_innew which contain indices
          %rather than  
    tem=ismember(Nodes,C_s_inround(i,1:3),'rows');
    ins(i)=find(tem==1);
    tem=ismember(Nodes,C_s_inround(i,4:6),'rows');
    outs(i)=find(tem==1);
    C_s_innew=[C_s_innew;[ins(i) outs(i)]];
end
for i=1:lb
    tem=ismember(Nodes,C_b_inround(i,1:3),'rows');
    inb(i)=find(tem==1);
    tem=ismember(Nodes,C_b_inround(i,4:6),'rows');
    outb(i)=find(tem==1);
    C_b_innew=[C_b_innew;[inb(i) outb(i)]];
end
% save Nodesss
% plotcbcs
end
    