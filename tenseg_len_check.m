% function [ len_hist ] = tenseg_len_check( History,tenseg )
% % NO LONGER NEEDED
% %[ len_hist ] = tenseg_len_check( History,tenseg ) computes bar length time
% %histories for each bar member in the given tensegrity structure defined in
% %tenseg based on the node time history contained in History. The purpose of
% %this is for evaluating the significance of numerical error in the
% %simulation data.
% %
% % Inputs:
% %    History: tensegrity simulation time history from tenseg_sim function
% %    tenseg: tensegrity definition structure used as input in
% %       tenseg_sim_function
% %
% % Outputs:
% %    len_hist: matrix containing bar length time histories for each bar
% %    member in the structure. Dimensions are s x beta, for beta bar
% %    members and s time steps.
% 
% 	C_b = tenseg.C_b; % Get bar connectivity
% 	len_hist = zeros(size(C_b,1),size(History.Nhist,3)); % Initialize length time history matrix
% 
% 	% Step through every node history time step, get bar lengths, and store as
% 	% columns
% 	for i=1:size(History.Nhist,3),
% 		N = History.Nhist(:,:,i);
% 		len_hist(:,i) = diag(sqrt(diag(diag(C_b*N'*N*C_b'))));
% 	end
% 	
% 	% Flip so lengths can be plotted with plot(len_hist)
% 	len_hist = len_hist';
% 	
% 	figure()
% 	pause(0.1)
% 	plot(len_hist)
% 
% end
% 
