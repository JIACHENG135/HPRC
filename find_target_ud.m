function [N_c,N_c_up,N_c_down,count] = find_target_ud(N,control_point,control_point_up,control_point_down,angle,ratio)
% angle is a vertor has the same length-1 as control_point
N_c = N(control_point,[1 3]);
N_new = N_c;
N_c_up = [];
N_c_down=[];
l = (N(control_point_up,3)-N(control_point_down,3))/2;
save l
count = 0;
for i = 2:length(control_point)
    N_temp = rotanew(N_c(i:end,:),N_c(i-1,:),angle*(ratio^(i-2)));
%     save N_temp
    k = (N_temp(1,2)- N_c(i-1,2))/(N_temp(1,1)- N_c(i-1,1));
    b = N_c(i-1,2) - (-1/k)*N_c(i-1,1);
%     check = N_c(i-1,:)-[N_c(i-1,1) k*N_c(i-1,1)]
    t=[0.0001:0.0001:1];
    for j = 1:length(t)
        x_temp_down = N_c(i-1,1)+t(j);
        x_temp_up = N_c(i-1,1)-t(j);
        y_temp_down = (-1/k)*x_temp_down + b;
        y_temp_up = (-1/k)*x_temp_up + b;
        dst(j) = eulerdst([x_temp_down y_temp_down],N_c(i-1,:));
        if abs(eulerdst([x_temp_down y_temp_down],N_c(i-1,:))-l(i-1))<0.001
            N_c_down = [N_c_down ;[x_temp_down y_temp_down]];
            N_c_up = [N_c_up ;[x_temp_up y_temp_up]];
            count = count +1
            break
        end
    end
    N_new(i:end,:) = N_temp;
    N_c = N_new;
    save l_test
end
end