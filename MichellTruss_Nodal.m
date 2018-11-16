function [N,r] = MichellTruss_Nodal(q,Beta,Phi,rq,r0)

a = sin(Beta)/sin(Beta + Phi);

r = zeros(1,q);
r(1) = r0;
for i = 1:1:q-1
    r(i+1) = a*r(i);
end
r(end+1) = rq;

%% Creating the Nodal Matrix
N = zeros(3,q);

%Creating one node matrix in between each cylinder 
iter = 0;
iter1 = 1;
for i =1:1:q+1
    for j = -(iter*Phi):2*Phi:(iter*Phi)
        N(:,iter1) = r(i)*[cos(j); sin(j);0];
        iter1 = iter1 + 1;
    end
    iter = iter + 1;
end