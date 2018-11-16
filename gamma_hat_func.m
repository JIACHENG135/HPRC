function gamma_hat = gamma_hat_func(S,s0)

s = sqrt(diag(diag(S'*S)));
k = 1;
% gamma_hat = k*(eye(size(s0,1)) - diag(diag(s0./s)));
gamma_hat = zeros(size(S,2),size(S,2));

for j=1:size(S,2)
    if s(j,j)>s0(j,j)
        gamma_hat(j,j) = k*(1-s0(j,j)/s(j,j));
    end 
end

end