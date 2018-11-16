% function [maxA,maxF,f,P1] = tenseg_freq(History,node,axis,viz)
% % DROPPING SUPPORT - Planning on deleting soon
% 
% % [maxA,maxF,f,P1] = TENSEG_FREQ(History,node,axis,viz) uses FFT analysis to
% % return the dominant frequency for a given node coordinate oscillation
% % from a given simulation time history. This is intended as a tool for
% % stiffness analysis.
% %
% % Inputs:
% %    History: simulation history data structure from tenseg_sim_[] function
% %    node: node number
% %    axis: axis label (1, 2, or 3)
% %    viz (optional): plot signal and FFT, default is ON
% %    
% %
% % Outputs:
% %    maxA: amplitude (one-sided) of dominant frequency as found by FFT
% %    maxF: max frequency of signal as found by FFT
% %    f: frequencies
% %    P1: magnitudes (maxF = f(P1==max(P1)), maxA = max(P1))
% 
% if nargin<4,
% 	viz = 1;
% end
% 
% S = squeeze(History.Nhist(axis,node,:));
% 
% L = numel(S);
% 
% Fs = 1/(History.t(2)-History.t(1));
% n = 2^nextpow2(L);
% 
% Y = fft(S,n);
% P2 = abs(Y/L);
% P1 = P2(1:L/2+1);
% P1(2:end-1) = 2*P1(2:end-1);
% f = Fs*(0:(L/2))/L;
% f(1) = []; P1(1) = [];
% 
% if viz,
% 	figure()
% 	plot(History.t,S)
% 	
% 	figure()
% 	plot(f,P1) 
% 	title('Single-Sided Amplitude Spectrum of X(t)')
% 	xlabel('f (Hz)')
% 	ylabel('|P1(f)|')
% end
% 
% maxF = f(P1==max(P1));
% maxA = max(P1);
% 
% end