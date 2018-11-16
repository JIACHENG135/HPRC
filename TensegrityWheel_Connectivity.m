function [CBT,CST] = TensegrityWheel_Connectivity(q)

%String Connectivity
CST = zeros(12*q,8*q);
iter = 0;
for i=1:1:q
    CST(1+iter:4+iter,1+2*iter:4+2*iter) = eye(4);
    CST(1+iter:4+iter,5+2*iter:8+2*iter) = eye(4);
    iter = iter + 4;
end%i
CST(4*q+1:end,:) = -eye(8*q);

%Bar Connectivity
CBT = zeros(12*q,8*q);

CBT(end-2:end,5:7) = -eye(3);
CBT(end-3,8) = -1;

CBT(5+4*(q-1):8+4*(q-1),1:4) = eye(4);
CBT(5+4*(q-1):end-4,5:end) = eye(4+8*(q-1));

I = zeros(4,4);
I(3:4,1:2) = -eye(2);
I(1:2,3:4) = -eye(2);
CBT(9+4*(q-1):12+4*(q-1),1:4) = I;

for i = 1:1:q-1
    CBT((17+4*(q-2))+8*(i-1):20+4*(q-2)+8*(i-1),9+8*(i-1):12+8*(i-1)) = I;
    CBT((21+4*(q-2))+8*(i-1):24+4*(q-2)+8*(i-1),13+8*(i-1):16+8*(i-1)) = I;
end%i

end%function