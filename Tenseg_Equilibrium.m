function [Force_den,Support_Load] = Tenseg_Equilibrium(tenseg_struct)

% Load in structure definitions
N = tenseg_struct.N;
C_s = tenseg_struct.C_s;
C_b = tenseg_struct.C_b;
W = tenseg_struct.W;
Pinned_nodes = tenseg_struct.Pinned_nodes;

  
for i = 1:size(N,2)
    E = [C_s'*diag(C_s(:,i)) -C_b'*diag(C_b(:,i))];
    K(3*i-2:3*i,:) = N*E;
end

% Pinned Nodes
nc = Pinned_nodes;
for i = 1:size(nc,2)
    K2(3*i-2:3*i,:) = K(3*nc(i)-2:3*nc(i),:);
end

S = N*C_s';
B = N*C_b';

W(:,nc) = [];
W_vec = reshape(W,[],1);

% Defined Loads
nd = 1:size(N,2);
nd(nc) = [];
for i = 1:size(nd,2)
    K1(3*i-2:3*i,:) = K(3*nd(i)-2:3*nd(i),:);
end

% Final Optimization
Force_den = linprog([],[],[],K1,W_vec,zeros(1,size(S,2)),[]);

if isempty(nc)
    Support_Load = 0;
else
    Support_Load = K2*Force_den;
end

end