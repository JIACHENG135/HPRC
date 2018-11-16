function W = variable_W(N,R,L,CST_Cables,p,q)

w = 3.86*2*pi/60;
Pressure = 1e5;
th_memb = 5e-03;
den_memb = 925;
den_air = 1.225;
m = 1.7128e+03;

%% -------------------Pressure Calculation---------------------------------

Surface_Area = 2*pi*R*L;
Pre_force_side = Surface_Area*Pressure;

%% ---------------- Pressure Forces ---------------------------------------

for i = 1:size(N,2)
    Pres_force_side(:,i) = Pre_force_side/size(N,2)*[N(1,i);N(2,i);0]/norm(N(1:2,i));
end

%% ----------------------- Centrifugal Membrane Forces --------------------

Mass_memb  =  Surface_Area*th_memb*den_memb/size(N,2);

for i = 1:size(N,2)
    Centr_force_memb(:,i) = Mass_memb*R*w*w*[N(1,i);N(2,i);0]/norm(N(1:2,i));
end

%% ----------------------- Centrifugal Air Forces -------------------------
 
Vol_cylinder  =  pi*R*R*L;
Mass_air  =  Vol_cylinder*den_air/size(N,2);

for i = 1:size(N,2)
    Centr_force_air(:,i) = Mass_air*R*w*w*[N(1,i);N(2,i);0]/norm(N(1:2,i));
end

%% ------------------------- Centrifugal string Forces --------------------
 
string_mass  =  m*ones(size(CST_Cables,2),1);
Mass_string_nodal  =  1/2*diag(CST_Cables*diag(string_mass)*CST_Cables');

for i = 1:size(N,2)
    Centr_force_string(:,i) = Mass_string_nodal(i)*R*w*w*[N(1,i);N(2,i);0]/norm(N(1:2,i));
end

%% ------------------------- Vertical Direction Forces --------------------
 
Cap_Area = pi*R*R;
Pre_force_top = Cap_Area*Pressure;

Pres_force_top = zeros(3,size(N,2));

for i = 1:2:2*p
    Pres_force_top(:,i) = Pre_force_top/p*[0;0;-1];
end

Pres_force_top(:,size(N,2)-p+1:size(N,2)) = kron(ones(1,p),Pre_force_top/p*[0;0;1]);

%% -------------------------- Total Force ---------------------------------
% W = Pres_force_side+Centr_force_memb+Centr_force_air+Centr_force_string+Pres_force_top;
W = Pres_force_top+Pres_force_side;
W_vec = reshape(W,[],1);

end