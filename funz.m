function y=funz(t,A,nmal_vec,size)
y1=nmal_vec(1)*(t(1)-A(1))...
    +nmal_vec(3)*(t(2)-A(3));
y2 = (t(1)-A(1))^2 +(t(2)-A(3))^2-size^2;
y = [y1 y2];
end
