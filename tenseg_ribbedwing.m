function [N,C_b,C_s,info] = tenseg_ribbedwing(NACA_desig,upper_panels,lower_panels,wing_length,ribs,viz)
% [N,C_b,C_s,info] =
% TENSEG_RIBBEDWING(NACA_desig,upper_panels,lower_panels,wing_length,ribs,viz)
% generates a tensegrity wing structure with class 2 ribs.
%
% Inputs:
%	NACA_desig: NACA 4-series designation (Example '2412')
%	upper_panels: number of line segments to use in approximating the
%		upper surface of the desired airfoil shape
%	lower_panels: number of lines segments to use in approximating the
%		lower surface of the desired airfoil shape
%	wing_length: length of wing (width is assumed to be 1)
%	ribs: number of ribs to use in spanning the length of the wing
%	viz (optional): turn figure generation on or off
%
% Outputs:
%	N: tensegrity wing node matrix
%	C_b: tensegrity wing bar connectivity
%	C_s: tensegrity wing string connectivity
%	info: various metrics for generated structure
%		[].rib_nodes: number of nodes per rib
%		[].rib_strings: number of internal strings per rib
%		[].stringers_per_rib: number of stringers per rib
%		[].tip_strings: number of strings for each wingtip


if nargin < 6,
	viz = 0;
end

[N,Nu,Nl] = wing_airfoil_nodes(NACA_desig,upper_panels,lower_panels);


%% Rib bar connectivity
C_b_in = [];
for i=1:size(Nu,2)-1,
	C_b_in(i,:) = [i i+1];
end
C_b_top = tenseg_ind2C(C_b_in,N);

C_b_in = [];
for i=1:size(Nl,2)-1,
	C_b_in(i,:) = size(Nu,2)+[i i+1];
end
C_b_bottom = tenseg_ind2C(C_b_in,N);

C_b_in = [1 size(Nu,2)+1; size(N,2) size(Nu,2)];
C_b_ends = tenseg_ind2C(C_b_in,N);

C_b_unit = [C_b_top; C_b_bottom; C_b_ends];


%% Rib string connectivity
C_s_in = combvec(1:size(Nu,2),size(Nu,2)+1:size(N,2))';
C_s_unit = tenseg_ind2C(C_s_in,N);


%% Get nodes of all ribs
number_of_ribs = ribs;
rib_spacing = (wing_length/(number_of_ribs-1));
rib_coords = 0:(wing_length/(number_of_ribs-1)):wing_length;

N_ribs = [];
for i=1:number_of_ribs,
	N_rib_add = N;
	N_rib_add(3,:) = rib_coords(i);
	N_ribs = [N_ribs, N_rib_add];
end
C_b = kron(eye(number_of_ribs),C_b_unit);
C_s = kron(eye(number_of_ribs),C_s_unit);
info.rib_strings = size(C_s_unit,1);
info.rib_nodes = size(N_rib_add,2);

if viz,
tenseg_plot(N_ribs,C_b,C_s);
end


%% Get stringer connectivity
n = size(N,2);
wrapN = @(x, Num) (1 + mod(x-1, n));

C_s_in = [];
for i=1:size(N,2),
	C_s_in = [C_s_in;
		      i wrapN(i-1)+size(N,2);
		      i i+size(N,2);
			  i wrapN(i+1)+size(N,2)];
end

C_s_stringers = [];
for i=1:number_of_ribs-1,
	C_s_stringers_unit = tenseg_ind2C((i-1)*size(N,2)+C_s_in,N_ribs);
	C_s_stringers = [C_s_stringers; C_s_stringers_unit];
end
info.stringers_per_rib = size(C_s_stringers_unit,1);

if viz,
tenseg_plot(N_ribs,C_b,C_s_stringers);
end


%% Add center bars
N_bar_loc = [0.25, (max(N(2,:))+min(N(2,:)))/2, 0]';
N_center = [];
for i=1:number_of_ribs,
	N_center(:,i) = [N_bar_loc(1:2); rib_coords(i)];
end

% Tips
N_center = [[N_bar_loc(1:2); rib_coords(1)-rib_spacing/4], N_center, [N_bar_loc(1:2); rib_coords(end)+rib_spacing/4]];
N_all = [N_ribs N_center];
C_b_in = [];
for i=1:number_of_ribs+1,
	C_b_in(i,:) = [i i+1];
end
C_b_in = C_b_in+size(N_ribs,2);
C_b_center = tenseg_ind2C(C_b_in,N_all);

C_b_all = [[C_b, zeros(size(C_b,1),number_of_ribs+2)]; C_b_center];

C_s_in = [];
for i=1:size(N,2),
	C_s_in(i,:) = [size(N_all,2)-(number_of_ribs+1) i];
end
C_s_wingtip1 = tenseg_ind2C(C_s_in,N_all);

C_s_in = [];
for i=1:size(N,2),
	C_s_in(i,:) = [size(N_all,2) size(N_all,2)-(number_of_ribs+2)-size(N,2)+i];
end
C_s_wingtip2 = tenseg_ind2C(C_s_in,N_all);


%% Combine string connectivity matrices
C_s_ribs_stringers = [[C_s; C_s_stringers],zeros(size(C_s,1)+size(C_s_stringers,1),number_of_ribs+2)];
C_s_all = [C_s_ribs_stringers; C_s_wingtip1; C_s_wingtip2];
info.tip_strings = size(C_s_wingtip1,1);

Np = [N_all(3,:); N_all(1,:); N_all(2,:)];

if viz,
	tenseg_plot(Np,C_b_all,C_s_all);
	view([-1 -1 1])
end

N = Np;
C_b = C_b_all;
C_s = C_s_all;





