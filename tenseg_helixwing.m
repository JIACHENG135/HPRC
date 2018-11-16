function [N,C_b,C_s] = tenseg_helixwing(NACA_designation,top_panels,bottom_panels,q,L)
% [N,C_b,C_s] =
% TENSEG_HELIXWING(NACA_designation,top_panels,bottom_panels,q,L) Generates
% a double helix tensegrity wing structure given a NACA 4-series airfoil
% shape, the number of 'panels' to use in approximating the upper and lower
% surfaces of the airfoil shape, the number of lenght-wise elements to use
% (q), and the length of the wing structure (L). The helix generation
% algorithm is pulled from a Nagase, Skelton publication titled "Double
% Helix Tensegrity Structures".
%
% Inputs:
%	NACA_designation: NACA 4-series airfoil designation (Ex '2412')
%	top_panels: Number of structural elements to use on upper surface of
%		airfoil (must be greater than 3?)
%	bottom_panels: Number of structural elements to use on lower surface
%		of airfoil (must be greater than 3?)
%	q: Number of structural elements to use along the length of the wing
%	L: Length of wing
%
% Outputs:
%	N: node matrix
%	C_b: Bar connectivity matrix
%	C_s: String connectivity matrix


% Get nodes approximating airfoil shape
[N,~,~] = wing_airfoil_nodes(NACA_designation,top_panels,bottom_panels);
N_AF = [N(:,1:top_panels+1), fliplr(N(:,top_panels+2:end))];


% Repeat with slightly different complexity for other direction -----------

% Specify approximation level (number of upper and lower panels)
midpoints = N_AF(1,1:end-1) + diff(N_AF(1,:))/2;
x2_top = midpoints(1:end/2);
x2_bottom = midpoints(end/2+1:end);

% % Get nodes approximating airfoil shape
[N_Q,~,~] = wing_airfoil_nodes_by_x(NACA_designation,x2_top,x2_bottom);
N_AF2 = [N_Q, [0;0;0]];

close all


% Base element bar connectivity--------------------------------------------
e1 = [1 0]';
e2 = [0 1]';

C_b_ipkm_T = [zeros(2,1), e2];
C_b_ipkp_T = [e1, zeros(2,1)];
E1 = C_b_ipkp_T;
E2 = C_b_ipkm_T;

% Base element string connectivity-----------------------------------------
C_s_ik_T = [e2-e1, -e2, zeros(2,1), e1, e2, -e1, zeros(2,2)];
C_s_ikm_T = [zeros(2,2), e2, -e2, -e2, zeros(2,2), -e2];
C_s_ipkm_T = [zeros(2,6), -e1, e2];
C_s_ipk_T = [zeros(2,1), e1, -e1, zeros(2,2), e1, e1, zeros(2,1)];
Theta1 = C_s_ikm_T;
Theta2 = C_s_ik_T;
Theta3 = C_s_ipkm_T;
Theta4 = C_s_ipk_T;

% Cylinder bar connectivity------------------------------------------------
p = top_panels+bottom_panels+1; %column units

% *****************************
% ** []_Bar is bar on bottom **
% ** Bar_[] is bar on top    **
% *****************************

E3_Bar = [zeros(2,2), e2];
E4_Bar = [eye(2), e1];

I_Bar = [];
for i=1:p-1,
	I_Bar = [I_Bar;
		     zeros(2,(i-1)*3), E4_Bar, -E3_Bar, zeros(2,(p-i-1)*3)];
end
I_Bar = [I_Bar;
	     -E3_Bar, zeros(2,(p-2)*3), E4_Bar];

E1_Bar = [E1, zeros(2,1)];
E2_Bar = [E2, zeros(2,1)];

PHI_Bar = [zeros(2,3), E2_Bar, zeros(2,(p-3)*3), E1_Bar];
for i=1:p-2,
	PHI_Bar = [PHI_Bar;
		       zeros(2,(i-1)*3), E1_Bar, zeros(2,3), E2_Bar, zeros(2,(p-i-2)*3)];
end
PHI_Bar = [PHI_Bar;
	       E2_Bar, zeros(2,(p-3)*3), E1_Bar, zeros(2,3)];

Bar_E1 = [1 0];
Bar_E2 = [0 1];

Bar_PHI = [Bar_E2, zeros(1,(p-2)*2), Bar_E1];
for i=1:p-1,
	Bar_PHI = [Bar_PHI;
		       zeros(1,(i-1)*2), Bar_E1, Bar_E2, zeros(1,(p-i-1)*2)];
end

PHI = [zeros(2,2), E2, zeros(2,(p-3)*2), E1];
for i=1:p-2,
	PHI = [PHI;
		   zeros(2,(i-1)*2), E1, zeros(2,2), E2, zeros(2,(p-i-2)*2)];
end
PHI = [PHI;
	   E2, zeros(2,(p-3)*2), E1, zeros(2,2)];

C_b_T = [-I_Bar, zeros(2*p,(q-1)*2*p);
	     PHI_Bar, -eye(2*p), zeros(2*p,(q-2)*2*p)];
for i=1:q-2,
	C_b_T = [C_b_T;
		     zeros(2*p,3*p), zeros(2*p,(i-1)*2*p), PHI, -eye(2*p), zeros(2*p,(q-i-2)*2*p)];
end
C_b_T = [C_b_T;
	     zeros(size(Bar_PHI,1), size(C_b_T,2)-size(Bar_PHI,2)), Bar_PHI];


% Cylinder string connectivity---------------------------------------------
Theta1_Bar = [Theta1(:,[1:3,5:8]), -e1];
Theta2_Bar = [Theta2(:,[1:3,5:8]), e1];
Theta3_Bar = [Theta3(:,[1:3,5:8]), zeros(2,1)];
Theta4_Bar = [Theta4(:,[1:3,5:8]), zeros(2,1)];

Bar_Theta1 = Theta1(:,[1,3:7]);
Bar_Theta2 = Theta2(:,[1,3:7]);
Bar_Theta3 = [1 0]*Theta3(:,[1,3:7]);
Bar_Theta4 = [1 0]*Theta4(:,[1,3:7]);

PSI1_Bar = [];
for i=1:p-1,
	PSI1_Bar = [PSI1_Bar;
		        zeros(2,(i-1)*8), Theta2_Bar, Theta1_Bar, zeros(2,(p-(i-1)-2)*8)];
end
PSI1_Bar = [PSI1_Bar;
	        Theta1_Bar, zeros(2,(p-2)*8), Theta2_Bar];

PSI2_Bar = [];
for i=1:p-1,
	PSI2_Bar = [PSI2_Bar;
		        zeros(2,(i-1)*8), Theta4_Bar, Theta3_Bar, zeros(2,(p-(i-1)-2)*8)];
end
PSI2_Bar = [PSI2_Bar;
	        Theta3_Bar, zeros(2,(p-2)*8), Theta4_Bar];

Bar_PSI1 = [];
for i=1:p-1,
	Bar_PSI1 = [Bar_PSI1;
		        zeros(2,(i-1)*6), Bar_Theta2, Bar_Theta1, zeros(2,(p-(i-1)-2)*6)];
end
Bar_PSI1 = [Bar_PSI1;
	        Bar_Theta1, zeros(2,(p-2)*6), Bar_Theta2];
		
Bar_PSI2 = [];
for i=1:p-1,
	Bar_PSI2 = [Bar_PSI2;
		        zeros(1,(i-1)*6), Bar_Theta4, Bar_Theta3, zeros(1,(p-(i-1)-2)*6)];
end
Bar_PSI2 = [Bar_PSI2;
	        Bar_Theta3, zeros(1,(p-2)*6), Bar_Theta4];

PSI1 = [];
for i=1:p-1,
	PSI1 = [PSI1;
			zeros(2,(i-1)*8), Theta2, Theta1, zeros(2,(p-(i-1)-2)*8)];
end
PSI1 = [PSI1;
	    Theta1, zeros(2,(p-2)*8), Theta2];
	
PSI2 = [];
for i=1:p-1,
	PSI2 = [PSI2;
		    zeros(2,(i-1)*8), Theta4, Theta3, zeros(2,(p-(i-1)-2)*8)];
end
PSI2 = [PSI2;
	    Theta3, zeros(2,(p-2)*8), Theta4];

C_s_T = [PSI1_Bar, zeros(2*p,(q-2)*8*p), zeros(2*p,6*p);
	     PSI2_Bar, PSI1, zeros(2*p,(q-3)*8*p), zeros(2*p,6*p)];
for i=1:q-3,
	C_s_T = [C_s_T;
		     zeros(2*p,i*8*p), PSI2, PSI1, zeros(2*p,(q-i-3)*8*p), zeros(2*p,6*p)];
end
C_s_T = [C_s_T;
	     zeros(2*p,(q-2)*8*p), PSI2, Bar_PSI1;
		 zeros(p,(q-1)*8*p), Bar_PSI2];


% Node generation ---------------------------------------------------------
for i=1:q+1,
	for k=1:p,
		n1 = [N_AF(1,k); N_AF(2,k); (2*i-1)*L/(2*q)];
		n2 = [N_AF2(1,k); N_AF2(2,k); (2*i)*L/(2*q)];
		N_store{i}{k} = [n1 n2];
	end
end

N = [];
for i=1:q+1,
	for k=1:p,
		if i<q+1,
			for j=1:2,
				N = [N, N_store{i}{k}(:,j)];
			end
		else
			N = [N, N_store{i}{k}(:,1)];
		end
	end
end

C_b = C_b_T';
C_s = C_s_T';

Ntemp = N;
N(1,:) = Ntemp(3,:);
N(2,:) = -Ntemp(1,:);
N(3,:) = Ntemp(2,:);
