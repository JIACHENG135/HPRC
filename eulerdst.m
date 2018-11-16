function d=eulerdst(X,Y)
sumd=0;
for i=1:length(X)
    sumd = sumd + (X(i)-Y(i))^2;
end
d = sqrt(sumd);
end