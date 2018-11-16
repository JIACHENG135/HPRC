% Example external force script
%
% This script is run at each time step in the simulation, allowing you to
% specify W in terms of N, Ndot, gamma, etc, etc

% To illustrate, this is setting an external force on each node that
%    opposes the velocity of the node
W = sin(t)*ones(size(N));
% W = Nd;