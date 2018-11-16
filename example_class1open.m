% EXAMPLE:
%    - Manual node matrix specification
%    - Manual connectivity matrix generation
%    - String member segmentation (string mass modeling)
%    - Manual string rest length specification
%    - Simulation

clear all; clc; close all;

% Specify node positions
N = [0.5 0 0; 0 0.866 0; -0.5 0 0; 0.5 0 1; 0 0.866 1; -0.5 0 1]';

% Specify bar connectivity
Cb_in = [3 5; 1 6; 2 4]; % Bar 1 connects node 3 to 5, etc
C_b = tenseg_ind2C(Cb_in,N);

% Specify string connectivity
Cs_in = [1 2; 2 3; 3 1; 4 5; 5 6; 6 4; 1 4; 2 5; 3 6]; % String one is node 1 to 2
C_s = tenseg_ind2C(Cs_in,N);

% Plot structure before string segmentation
tenseg_plot(N,C_b,C_s);

%%
% Divide strings into a number of segments
segments = 3;
[N,C_b,C_s,parents] = tenseg_string_segment(N,C_b,C_s,segments);

% Plot structure to see what string segmentation looks like
plot_handle = tenseg_plot(N,C_b,C_s);


%%
%Specify resting string lengths

% Here, we're setting every string rest length to 70% of its given length
S_0_percent = [(1:size(C_s,1))', 0.7*ones(size(C_s,1),1)]; % percent of initial lengths

% This function converts those specified percentages into rest lengths
s_0 = tenseg_percent2s0(N,C_s,S_0_percent,parents);


%%
% Create data structure defining structure simulation task
prism.N = N;
prism.C_b = C_b;
prism.C_s = C_s;
prism.s_0 = s_0;

% These are optional inputs. If unspecified, default values will be loaded.
%    check tenseg_defaults.m to see/change these default values
prism.video = 0; % This turns off automatic animation output
prism.tf = 3;    % This sets the final simulation time to 3 sec 
prism.dt = 0.02; % This sets the simulation time step to 0.02 sec


% Perform Simulation
% History is a data structure containing simulation results
% sim_debug is a data structure containing a bunch of internally used variables
[History,sim_debug] = tenseg_sim_class1open(prism);

%%
% Plot coordinate time histories for nodes
close all
tenseg_plot_node(History,1,[],'b-.') % plot all three axis for node 1
tenseg_plot_node(History,5,[],'r')   % in same plot, plot same for node 5

figure()
tenseg_plot_node(History,[2 3 4],[1 3])    % plot x and y coordinates for nodes 2,3,4
                                           % not super useful because all
                                           % same colors right now...

%%
% Create animation of simulation results
% Use 'History' time histories for 'prism' structure, save avi named 'example_class1open'
tenseg_animation(History,prism,'example_class1open')
