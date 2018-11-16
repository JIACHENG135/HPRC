clear all; clc; close all;

[N,C_bT,C_sT] = tenseg_prismplate(1,0.05);
C_b = C_bT';
C_s = C_sT';

tenseg_plot(N,C_b,C_s)
axis equal



%%
% Create input structure
tenseg.N = N;
tenseg.C_b = C_b;
tenseg.C_s = C_s;

[s_0_equil,gamma_equil] = tenseg_equil(tenseg);

tenseg.s_0_const = s_0_equil;
tenseg.video = 0;
%%
S = N*C_s';
N_bottom_ind = N(3,:)==0;
bottom_strings_check = N_bottom_ind*abs(C_s)';
bottom_strings_ind = bottom_strings_check==2;
s_0_equil_new = s_0_equil;
s_0_equil_new(bottom_strings_ind) = 0.6*s_0_equil(bottom_strings_ind);

tf = 5;
dt = 0.01;
s_0_hist = zeros(size(s_0_equil,1),tf/dt+1);
for i=1:size(s_0_equil_new,1),
	s_0_hist(i,:) = linspace(s_0_equil(i),s_0_equil_new(i),tf/dt+1);
end
s_0_hist = [s_0_hist, kron(s_0_equil_new,ones(1,tf/dt))];
tf = 10;
tenseg.tf = tf;

tenseg.s_0_const = s_0_hist;

%%
close all;

% Perform Simulation
[History,tenseg_debug] = tenseg_sim_class1open(tenseg);
%%
% Create animation of simulation results
tenseg_animation(History,tenseg_debug.structure,'prism_test1',[],[1 0 0])

%(History,tenseg_struct,filename,highlight_nodes,view_vec)