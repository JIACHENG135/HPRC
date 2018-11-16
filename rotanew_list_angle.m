function N=rotanew_list_angle(a,b,c)
% col in rows out
% a rotate b with c
N=[];
if ~isempty(a)
    for i=1:length(a(:,1))
        x=a(i,1);y=a(i,2);
        rx0=b(1);ry0=b(2);
        x0= (x - rx0)*cos(c)- (y - ry0)*sin(c) + rx0 ;
        y0= (x - rx0)*sin(c) + (y - ry0)*cos(c) + ry0 ;
        N=[N;x0 y0];
    end
end
end