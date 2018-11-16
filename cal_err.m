function err = cal_err(A)
[a,b] = size(A);
err = zeros(size(A(1,:)));
for i = 1:a
    err = err + A(i,:).^2;
end
err = err.^(1/2);
end