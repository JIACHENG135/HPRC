function [] = tenseg_animation(History,tenseg_struct,file,highlight_nodes,view_vec,realtime)
% [] =
% TENSEG_ANIMATION(History,tenseg_struct,filename,highlight_nodes,view_vec,realtime)
% creates an animation video file for a given tensegrity sim history and
% the topology of the structure
%
% Inputs:
%	History: simulation results from tenseg_sim_[] functions. Mainly just
%		using History.Nhist, which is a 3xnxt array containing node
%		positions for all n nodes in the structure at all t time steps in
%		the simulation   
%	tenseg_struct: tensegrity structure definition data structure
%		containing bar and string connectivity matrices
%	filename (optional): path/filename for video file
%	highlight_nodes (optional): node(s) to highlight when plotting (vector
%		containing node numbers)
%	view_vec (optional): plotting view direction (see view())
%	realtime (optional): force animation video file to be in real-time
%		(1sec = 1sec)
%
% Example:
%	[hist,info] = tenseg_sim_class1open(prism);
%	tenseg_animation(hist,prism)


Nhist = History.Nhist; % Node matrix history
C_b = tenseg_struct.C_b; % Connectivity matrices
C_s = tenseg_struct.C_s;
filename = file.filename;
Path = file.Path;
% Handle optional inputs
if nargin < 3 || isempty(filename)
	filename = 'test'; % default file name
end
if nargin < 4
	highlight_nodes = []; % default nodes to highlight
end
if nargin < 5
	view_vec = []; % default view vector
end
if nargin < 6
	realtime = 1; % default realtime video framerate option
end


% Initialize video save file

vid = VideoWriter(filename,'MPEG-4');

% Figure out framerate and number of steps to skip to make realtime
if realtime
	% Determine true framerate based on t_span
	true_framerate = numel(History.t)/History.t(end);
	
	% Limit framerate to 30 fps
	if true_framerate >= 30
		vid.FrameRate = 30;
		
		% Determine # of frames to skip based on framerate
		frame_skip = round(true_framerate/vid.FrameRate);
	else
		vid.FrameRate = round(true_framerate);
		frame_skip = 1;
	end
else
	% If not realtime, just print every frame
	frame_skip = 1;
end
% vid.path = Path;
open(vid);
% Create figure in which to plot each frame
fig = figure();
% Determine view/axes based on Node matrix history
[axis_vec, view_vec_derived] = tenseg_axisview(Nhist);
% If no view vector defined, use the one derived from Nhist
if isempty(view_vec),
	view_vec = view_vec_derived;
end
% Go through all time steps, plot, adjust axes, and write to video file
for i=1:frame_skip:size(Nhist,3)
	N = Nhist(:,:,i);
	fig = tenseg_plot(N,C_b,C_s,fig,highlight_nodes,view_vec);
	axis equal
 	axis(axis_vec)
	
	% Get frame width/height and write frame (including axes) to file
	position = get(gcf,'Position'); % do this to include axes in video
%     filepath = [pwd,'\Videos\']
	writeVideo(vid,getframe(gcf,[0 0 position(3:4)]));
% 	writeVideo(vid,position);
	clf
end
close(vid);
