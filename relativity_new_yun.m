function [max_a,max_elongation,max_position,travel_time]=relativity_new_yun(Hist_temp)

% [Hist,debug] = tenseg_sim_classkopen_old(classK_test);
%% history structure
Hist = Hist_temp.Hist ;
dt = Hist_temp.dt;
C_s_new = Hist_temp.C_s_new;
S_0_percent = Hist_temp.S_0_percent;
s_0 = Hist_temp.s_0;
tf = Hist_temp.tf;
% plotStructure = Hist_temp.plotStructure;
perc = Hist_temp.perc;
%% plotA
[max_a,max_elongation,max_position,travel_time]=plotA_newfigure(Hist,dt,C_s_new,S_0_percent,s_0,tf,perc);
end