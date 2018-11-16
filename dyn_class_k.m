function dy = dyn_class_k(t,x0,Inp)
Cs = Inp.Cs;Cb = Inp.Cb;W = Inp.W;s0 = Inp.s0;b0 = Inp.b0;P=Inp.P;D=Inp.D;
X2 = x0(1:numel(x0)/2);
X2d = x0(numel(x0)/2+1:end);
[U,Ez,V] = svd(P);
U1 = U(:,1:size(P,2));U2 = U(:,size(P,2)+1:end); E0 = Ez(1:size(P,2),:);
n = size(Cb,2); % number of nodes
nb = size(Cb,1); % number of bars
X2 = reshape(X2,3,size(U2,2));
X2d = reshape(X2d,3,size(U2,2));
l_hat = (b0)^(1/2);
X1 = D*V*E0^-1;
N = [X1 X2]*U';
Nd = [0*X1 X2d]*U';
% [N,Nd]=bar_length_correction_ClassK(N,Nd,Cb,P,D,l_hat);
X2d = Nd*U2;
B = N*Cb';S=N*Cs';Bd = Nd*Cb';
m=1; % mass of each bar
M = m*[(1/12)*eye(nb) 0*eye(nb);0*eye(nb) eye(nb)];
gamma_hat = gamma_hat_func(S,s0);

% calculate Omg : Lagrange Multiplier

% lambda_hat_0 = diag(diag(0.5*l_hat_2pow*B'*(S*gamma_hat*Cs-W)*Cb'-(1/12)*l_hat_2pow*(m*eye(nb))*Bd'*Bd));
% Phi_0 = (N*S*gamma_hat*Cs-N*Cb'*lambda_hat_0*Cb-W)*M^-1*P;
% p = Cb*P;
% for i=1:size(Cb,2)
%     for j=1:3
%         
%     end
% end
kC = P'*Cb';kD = Cb*M^-1*P;kE=P'*M^-1*P;E = eye(size(kE,1));
kA = -S*gamma_hat*Cs*M^-1*P+B*diag(diag(0.5*l_hat^-2*B'*(S*gamma_hat*Cs-W)*Cb'-(1/12)*l_hat^-2*(m*eye(nb))*Bd'*Bd))*Cb*M^-1*P+W*M^-1*P;
Omg=0;
for i=1:size(kC,2)
    Omg=Omg+(1/(2*l_hat(i,i)^2))*kron(kC(:,i)',kron(B(:,i),(B(:,i)*kD(i,:))'));
end
Omg = (Omg - [kron(kE,E(1,:));kron(kE,E(2,:));kron(kE,E(3,:))])\[kA(:,1);kA(:,2);kA(:,3)]; 
Omg = reshape(Omg,numel(Omg)/size(P,2),size(P,2));
lambda_c = diag(diag(0.5*l_hat^-2*B'*(S*gamma_hat*Cs-W-Omg*P')*Cb'-(1/12)*l_hat^-2*(m*eye(nb))*Bd'*Bd));
K = Cs'*gamma_hat*Cs - Cb'*lambda_c*Cb;
%K = pinv(N)*(W*M^-1*U1 + Omg*P'*M^-1*U1)*pinv(U1);
M_til = U2'*M*U2; 
K_til = U2'*K*U2;
W_til = W*U2-D*V*E0^-1*U1'*K*U2;
X2dd = (W_til-X2*K_til)*M_til^-1;
dy = [reshape(X2d,numel(X2d),1);reshape(X2dd,numel(X2dd),1)];
end