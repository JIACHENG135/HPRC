function [NN,phi,q]=MichellWheel(q,Phi,Beta,rq,r0)
% clear all; clc; close all; 
% % Inputs
% rq = 1; %<m>
% r0 = 20; %<m>
% Beta = pi/6;
% Phi = pi/12;
% q = 8;

% [CBT,CST] = MichellTruss_Connectivity(q);
[N,r] = MichellTruss_Nodal(q,Beta,Phi,rq,r0);
phi=Phi;
p = (pi)/Phi;
NN(1,:,1) = N(1,:);
NN(2,:,1) = N(2,:);
NN(3,:,1) = N(3,:);
for j = 1:1:p
    NN(1,:,j+1) = NN(1,:,j)*cos(2*Phi) - NN(2,:,j)*sin(2*Phi);
    NN(2,:,j+1) = NN(1,:,j)*sin(2*Phi) + NN(2,:,j)*cos(2*Phi);   
end
% end

%% Plotting the truss
%figure(2)
%TensegrityPlot(N,CBT,CST),hold on
%Plotting the circles
% for i = 1:1:q+1
%     x = 0; y = 0;
%     th = 0:pi/50:2*pi;
%     xunit = r(i) * cos(th) + x;
%     yunit = r(i) * sin(th) + y;
%     h = plot(xunit, yunit,'g--'),hold on;
% %     hold on
% end
% title('Single Michell Truss')
% xlabel('x-direction <m>')
% ylabel('y-direction <m>')
% hold on
%%
% figure(3)
% for i = 1:1:p
%     TensegrityPlot(NN(:,:,i),CBT,CST)
%     hold on;
% end

%%
% TensegrityPlot(NN,CBT,CST),hold on
% %Plotting the circles
% for i = 1:1:q
%     x = 0; y = 0;
%     th = 0:pi/50:2*pi;
%     xunit = r(i) * cos(th) + x;
%     yunit = r(i) * sin(th) + y;
%     h = plot(xunit, yunit,'g--'),hold on;
% end
% title('Rotated Michell Truss')
% xlabel('x-direction <m>')
% ylabel('y-direction <m>')