function [p,nodes,C_b_in]=genedbar(N,phi,q)
global count C_s_in
count=count+1;
[b(count),a]=size(N);
%     n1=zeros(a,2);
%     n2=zeros(a,2);
%     n3=zeros(a,2);
%     n4=zeros(a,2);
%     tem=4*b(count);
    p=zeros(4*b(count),4);
    nodes=zeros(4*b(count),4);
    C_b_in=zeros(4*b(count),6);
%     C_s_in=zeros(b,2);
    
    for i=1:b(count)
%         i;
        n1=N(i,[1 2]);
        n2=N(i,[3 4]);
%         l=eulerdst(n1',n2');
        sc=1/(2*cos(phi));
        P=(n2-n1).*sc+n1;
        n3=rota(P,n1,2*pi-phi);
        n3=n3';
        n4=rota(P,n1,phi);
        n4=n4';
%         ax=[n1,n3;n1,n4;n2,n3;n2,n4];
%         key2=n2;
%         if n3(1)<key2(1)
%             p((i-1)*4+3,:)=[n3,n2];
%         else
%             p((i-1)*4+3,:)=[n2,n3];
%         end
%         if n4(1)<key2(1)
%             p((i-1)*4+4,:)=[n4,n2];
%         else
%             p((i-1)*4+4,:)=[n2,n4];
%         end
        p((i-1)*4+1:(i-1)*4+4,:)=[n1,n3;n1,n4;n2,n3;n2,n4];
%         p((i-1)*4+1:(i-1)*4+4,:)=[n1,n3;n1,n4;n2,n3;n2,n4];
%         n2,n3;n2,n4];
%         X=[n1(1) n3(1) n];
% %         Y=[n1(2)]
%         X=[n1(1) n3(1) n1(1) n4(1) n2(1) n3(1) n2(1) n4(1)];
%         Xd=[n3(1) n4(1)];
% %         X=[p(1,1) p(1,3) p(1,1) p(2,3) p(3,1) p(1,3) p(3,1) p(2,3)];
%         Y=[n1(2) n3(2) n1(2) n4(2) n2(2) n3(2) n2(2) n4(2)];
%         Yd=[n3(2) n4(2)];
% %         Y=[p(1,2) p(1,4) p(1,2) p(2,4) p(3,2) p(1,4) p(3,2) p(2,4)];
%         plot(X,Y,'black'),hold on
%         axis equal

%     b=[b,n3,n4];
%     a=[n3;n4];
        nodes(4*(i-1)+1,:)=[p((i-1)*4+1,[1 2]) 0 4*(i-1)+1];
        nodes(4*(i-1)+2,:)=[p((i-1)*4+3,[1 2]) 0 4*(i-1)+3];
        nodes(4*(i-1)+3,:)=[p((i-1)*4+3,[3 4]) 0 4*(i-1)+2];
        nodes(4*(i-1)+4,:)=[p((i-1)*4+4,[3 4]) 0 4*(i-1)+4];

%         nodes(4*(i-1)+2,:)=P((i-1)*4+2,[3 4]);
%         nodes(4*(i-1)+3,:)=P((i-1)*4+3,[1 2]);
%         nodes(4*(i-1)+4,:)=P((i-1)*4+3,[3 4]);
%         C_b_in=[1 3;1 4;2 3;2 4];
        
%     end
        nodes(find(abs(nodes)<0.001))=0;
% % % %% set off duplicate
% % %     Nn=nodes(:,1:3)';
% 
%     nn=unique(Nn,'rows');
%     a=zeros(length(Nn(:,1)),length(nn(:,1)));
%     B=zeros(1,length(nn(:,1)));

%     for i=1:length(nn(:,1))
%         a(:,i)=(ismember(Nn,nn(i,:),'rows'));
% 
%     end
%     for i=1:length(nn(:,1))
% %         colmnodes(a(:,i))=i;
% 
%         B(i)=find(a(:,i),1,'first');
%         [c,d]=find(a(:,i)==1)
%         nodes(c,4)=nodes(B(i),4);
%     end
%     for i=1:b(count)
        C_b_in(4*(i-1)+1,:)=[nodes(4*(i-1)+1,1:3) nodes(4*(i-1)+2,1:3)];
        C_b_in(4*(i-1)+2,:)=[nodes(4*(i-1)+1,1:3) nodes(4*(i-1)+4,1:3)];
        C_b_in(4*(i-1)+3,:)=[nodes(4*(i-1)+3,1:3) nodes(4*(i-1)+2,1:3)];
        C_b_in(4*(i-1)+4,:)=[nodes(4*(i-1)+3,1:3) nodes(4*(i-1)+4,1:3)];
        C_s_in=[C_s_in;nodes(4*(i-1)+3,1:3) nodes(4*(i-1)+2,1:3)];
%     end
%% set off duplicated nodes
%     colmnodes=unique(nodes(:,4));
%     isinnn=zeros(length(nn(:,1)),length(colmnodes));
%     newnodes=[];
%     for i=1:length(colmnodes)
%         isinnn(:,i)=ismember(nn,Nn(colmnodes(i),:),'rows');
%         newnodes=[newnodes,find(isinnn(:,i),1,'first')];
%     end
%     CC_b_in=C_b_in;
%     CC_s_in=C_s_in;
%     for i=1:length(newnodes)
%         C_b_in(find(CC_b_in==colmnodes(i)))=newnodes(i);
%         C_s_in(find(CC_s_in==colmnodes(i)))=newnodes(i);
%     end
%     for i=1:length(newnodes)
%         newnn(i,:)=nn(newnodes(i),:)
%     end
%     nnn=newnn';
%     K=Nn-nn
%     nn=nn';
    save a
    end
end
