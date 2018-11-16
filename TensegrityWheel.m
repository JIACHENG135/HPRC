clear variables; clc; close all;

deg2rad = pi/180;

q = 1;
r = 1;
R = 20;
alpha = 0*deg2rad + pi/2;

%% Connectivity Matrices
% [CBT,CST] = TensegrityWheel_Connectivity(q);

%% Nodal Matrix

% TensegrityPlot(N,CBT,CST)
% hold on;
%Plotting the circles
r = [r,R];
for i = 1:1:2
    x = 0; y = 0;
    hold on
    th = 0:pi/50:2*pi;
    xunit = r(i) * cos(th) + x;
    yunit = r(i) * sin(th) + y;
    h = plot(xunit, yunit,'g--');
end










 