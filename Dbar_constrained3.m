function [N,Cb,Cs,P,D] = Dbar_constrained3(b,th)
%b = bar length
%th = theta of the initial configuration wrt base. 
% defining the columns of P
N = [2 1 1 0 0 0;
     0 1 -1 0 2 -2;
     0 0 0  0 0 0];
 
Css=[2 5;3 6;1 4;2 3];
Cs=zeros(size(Css,1),size(N,2));                                %Cs is connectivity matrix
for i=1:size(Cs,1)
    Cs(i,min(Css(i,:)))=-1;
     Cs(i,max(Css(i,:)))=1;
end

Cbs=[1 2;1 3;2 4;3 4;4 5;4 6];
Cb=zeros(size(Cbs,1),size(N,2));                                %Cb is connectivity matrix
for i=1:size(Cb,1)
    Cb(i,min(Cbs(i,:)))=-1;
     Cb(i,max(Cbs(i,:)))=1;
end


P = [0 0 0 1 0 0
    0 0 0 0 1 0
    0 0 0 0 0 1]';
D = N*P;

end