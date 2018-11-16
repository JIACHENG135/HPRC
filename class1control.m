function dy = class1control(t,x0,Inp)
Cs = Inp.Cs;Cb = Inp.Cb;W = Inp.W;s0 = Inp.s0;b0 = Inp.b0;m=Inp.m;
L1=Inp.L1;R1=Inp.R1;Yt=Inp.Yt;%Y2t=Inp.Y2t;R2=Inp.R2;L2=Inp.L2;
persistent s0hist
s0hist(:,1)=zeros(size(s0,1),1);
N = x0(1:numel(x0)/2);
Nd = x0(numel(x0)/2+1:end);
n = size(Cb,2); % number of nodes
nb = size(Cb,1); % number of bars
ns = size(Cs,1); % number of strings

N = reshape(N,3,n);
Nd = reshape(Nd,3,n);

% perform barlength correction
% [N,Nd] = barlengthcorrect(N,Nd,Cb,b0);
[N,Nd] = bar_length_correction_Class1(N,Nd,Cb,b0);

Bd = Nd*Cb';
Sd = Nd*Cs';
B = N*Cb';
S = N*Cs';
Cr=(1/2)*abs(Cb);
% M = m.*[(1/12)*eye(nb) 0*eye(nb);0*eye(nb) eye(nb)];
m_hat = m.*eye(nb);
M = (1/12)*Cb'*m_hat*Cb + (1/4)*Cr'*m_hat*Cr;
l_hat = sqrt(diag(diag(B'*B)));
EYE = eye(nb);
biglambda = []; tau = [];
for i=1:nb
    biglambda = [biglambda;(-1/(2*l_hat(i,i)^2))*B(:,i)'*S*diag(Cs*Cb'*EYE(:,i))];
    tau = [tau;(1/(2*l_hat(i,i)^2))*B(:,i)'*W*Cb'*EYE(:,i)+ (1/(12*l_hat(i,i)^2))*m*norm(Bd(:,i))^2];
end

Acon1 = 2*eye(size(L1,1));
Bcon1 = 1*eye(size(L1,1));
BTu1 = L1*W*(M^-1)*R1 + Acon1*L1*Nd*R1 + Bcon1*(L1*N*R1-Yt);

BIGTAU=[];meu=[];
EYE = eye(size(R1,2));

for i=1:size(R1,2) % corrected the iteration i
BIGTAU = [BIGTAU;L1*(S*diag(Cs*M^-1*R1*EYE(:,i))+B*diag(Cb*M^-1*R1*EYE(:,i))*biglambda)];
meu = [meu;BTu1*EYE(:,i) - L1*B*diag(Cb*M^-1*R1*EYE(:,i))*tau];
end

options = optimoptions('lsqlin','Display','off');
% [gammas,fval,exitflag] = linprog(ones(ns,1),[],[],BIGTAU,meu,zeros(ns,1),[],options);
% if (numel(gammas) ~=ns)
%     gammas = lsqlin(BIGTAU,meu,[],[],[],[],zeros(ns,1),1*ones(ns,1),[],options);
% end
gammas = lsqlin(BIGTAU,meu,[],[],[],[],zeros(ns,1),[],s0hist(end),options);
s0hist = [s0hist gammas];
gamma_hat = diag(gammas);
% plot(t,gammas(3),'-o')
% hold on
lambda_c = diag(-biglambda*gammas-tau);
K = Cs'*gamma_hat*Cs - Cb'*lambda_c*Cb;
Ndd = (W-N*K)*M^-1;
dy = [reshape(Nd,[],1);reshape(Ndd,[],1)];
end