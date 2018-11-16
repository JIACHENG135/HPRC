function C = compat_3(A,B)
[a1,b1,c1] = size(A);
[a2,b2,c2] = size(B);
if (a1~=a2)||(b1~=b2)
    disp('Dimention doesn''t match')
    return
else
    C = zeros(a1,b1,c1+c2);
    for i =1:(c1+c2)
        if i>c1
            C(:,:,i) = B(:,:,i-c1);
        else
            C(:,:,i) = A(:,:,i);
        end
    end
end
end