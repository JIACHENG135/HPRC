function dy = dyn_class_1(t,x0,Inp)
Cs = Inp.Cs;Cb = Inp.Cb;W = Inp.W;s0 = Inp.s0;b0 = Inp.b0;m=Inp.m;

XN = x0(1:numel(x0)/2);
XNd = x0(numel(x0)/2+1:end);

n = size(Cb,2); % number of nodes
N = reshape(XN,3,n);
Nd = reshape(XNd,3,n);

% perform barlength correction
[N,Nd] = barlengthcorrect(N,Nd,Cb,b0);

% [N,Nd] = bar_length_correction_Class1(N,Nd,Cb,b0);
Bd = Nd*Cb';    
B = N*Cb';
S = N*Cs';
% l_hat_2pow = 1.41^-2 * eye(size(B,2));
l_hat_2pow = (b0)^-2;
gamma_hat = gamma_hat_func(S,s0);
% m = 1;
m_hat = m*eye(size(B,2));
lambda_hat = 0.5*l_hat_2pow*diag(diag(B'*(N*Cs'*gamma_hat*Cs-W)*Cb')) - (1/12)*l_hat_2pow*m_hat*diag(diag(Bd'*Bd));
K = Cs'*gamma_hat*Cs - Cb'*lambda_hat*Cb;
M = [m_hat/12 zeros(size(m_hat,1),size(m_hat,2));zeros(size(m_hat,1),size(m_hat,2)) m_hat];
Ndd = (W-N*K)*M^-1;
dy = [reshape(Nd,numel(Nd),1);reshape(Ndd,numel(Ndd),1)];
% scatter(t,lambda_hat(1,1),'b')
% hold on
end