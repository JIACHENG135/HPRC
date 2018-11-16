function [CN,CNd] = barlengthcorrect(N,Nd,Cb,b0)
q=5;
B=N*Cb';
Bd = Nd*Cb';
for i=1:size(Cb,1)
    a0 = (q*b0(i,i))^2 * (Bd(:,i)'*Bd(:,i)) * ((B(:,i)'*Bd(:,i))^2 - (B(:,i)'*B(:,i))*(Bd(:,i)'*Bd(:,i))) ;
    a1 = 2*(q*b0(i,i))^2 * ((B(:,i)'*Bd(:,i))^2 - (Bd(:,i)'*Bd(:,i)) * (B(:,i)'*B(:,i)));
    a2 = Bd(:,i)'*Bd(:,i)*Bd(:,i)'*Bd(:,i) - (q*b0(i,i))^2*(B(:,i)'*B(:,i));
    a3 = 2*Bd(:,i)'*Bd(:,i);
    x = roots([1 a3 a2 a1 a0]);
    x= x(imag(x)==0);
    % search for the minimum value in the cost function
    for j=1:numel(x)
    v = pinv(x(j)*eye(size(Cb,1))+Bd(:,i)*Bd(:,i)')*q*b0(i,i)*B(:,i);
    p = b0(i,i)*v-B(:,i);
    r = -v*v'*Bd(:,i);
    J(j) = q*norm(p)^2+norm(r)^2;
    end
    [Jval,Jpos] = min(J);
    x = x(Jpos);
    v = inv(x*eye(3)+Bd(:,i)*Bd(:,i)')*q*b0(i,i)*B(:,i);
    p = b0(i,i)*v-B(:,i);
    r = -v*v'*Bd(:,i);
    B(:,i) = B(:,i)+p;
    Bd(:,i) = Bd(:,i)+r;
    
end
CN = B*pinv(Cb');
CNd = Bd*pinv(Cb');
end