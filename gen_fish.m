function [N,C_b_in,C_s_in]=gen_fish(n,ls,lb)
if n>1
    C_b_in=zeros(2,2*n)';
    C_s_in=zeros(2,2*(n-1))';
    N=zeros(2,3*n);
%     lb=[lb(1) lb];
    for i=1:n
        C_b_in(2*(i-1)+1,:)=[3*(i-1)+2,3*(i-1)+3];
        C_b_in(2*(i-1)+2,:)=[3*(i-1)+1,3*(i-1)+4];
        if i>1
            C_s_in(2*(i-1)+1-2,:)=[3*(i-1)+2,3*(i-1)-2];
            C_s_in(2*(i-1)+2-2,:)=[3*(i-1)+3,3*(i-1)-2];
        end
        if i==1
            N(:,3*(i-1)+1)=[0;0];
            N(:,3*(i-1)+2)=[0;ls/2];
            N(:,3*(i-1)+3)=[0;-ls/2];
        else
            N1=N(:,3*(i-2)+1);
            N2=N(:,3*(i-2)+2);
            N3=N(:,3*(i-2)+3);
            N(:,3*(i-1)+1)=[N1(1)+lb(i-1);0];
            N(:,3*(i-1)+2)=[N2(1)+lb(i-1);ls/2];
            N(:,3*(i-1)+3)=[N3(1)+lb(i-1);-ls/2];             
        end
    end
    N=[N [N(1,3*(i-1)+1)+lb(i);0]];
else
    disp('n should bigger than 1')
end