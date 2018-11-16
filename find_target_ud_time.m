function [N_c_k,N_c_up,N_c_down,set_len] = find_target_ud_time(N,control_point,control_point_up,control_point_down,angle,ratio,omega)
% angle is a vertor has the same length-1 as control_point
N_c_up = {};
N_c_down={};
N_temp_k = {};
l = (N(control_point_up,3)-N(control_point_down,3))/2;
save l
count = 0;
angle_set =[omega:omega:angle];
set_len = length(angle_set);
for kk=1:length([omega:omega:angle])
    N_c = N(control_point,[1 3]);
    N_new = N_c;
    N_c_down_temp=[];
    N_c_up_temp=[];
    for i = 2:length(control_point)
        N_temp_k{1,kk} = rotanew(N_c(i:end,:),N_c(i-1,:),angle_set(kk)*(ratio^(i-2)));
        %     save N_temp
        N_temp =N_temp_k{1,kk};


        k = (N_temp(1,2)- N_c(i-1,2))/(N_temp(1,1)- N_c(i-1,1));
        b = N_c(i-1,2) - (-1/k)*N_c(i-1,1);
        %     check = N_c(i-1,:)-[N_c(i-1,1) k*N_c(i-1,1)]
        t=[0.000001:0.000001:1];
        for j = 1:length(t)
            x_temp_down = N_c(i-1,1)+t(j);
            x_temp_up = N_c(i-1,1)-t(j);
            y_temp_down = (-1/k)*x_temp_down + b;
            y_temp_up = (-1/k)*x_temp_up + b;
            dst(j) = eulerdst([x_temp_down y_temp_down],N_c(i-1,:));
            if abs(eulerdst([x_temp_down y_temp_down],N_c(i-1,:))-l(i-1))<0.001
%                 [x_temp_down y_temp_down]
                N_c_down_temp = [N_c_down_temp ;[x_temp_down y_temp_down]];
                N_c_up_temp = [N_c_up_temp ;[x_temp_up y_temp_up]];
                count = count +1
                break
            end
        end
        N_new(i:end,:) = N_temp;
        N_c= N_new;
    end
    N_c_down{1,kk} = N_c_down_temp;
    N_c_up{1,kk} = N_c_up_temp;
    N_c_k{1,kk} = N_c;
end
end