function [axis_vec, view_vec] = tenseg_axisview(Nhist)
% [axis_vec, view_vec] = TENSEG_AXISVIEW(Nhist) finds axes bounds and an
% appropriate view vector for visualizing data from a provided node matrix
% or node history array.
%
% Inputs:
%	Nhist: node matrix or node history array (3 x n x t)
%
% Outputs:
%	axis_vec: min and max axes values
%	view_vec: viewing direction for visualization

% Get min and max X,Y,Z coordinates contained in Nhist
min_x = min(min(Nhist(1,:,:)));
max_x = max(max(Nhist(1,:,:)));
min_y = min(min(Nhist(2,:,:)));
max_y = max(max(Nhist(2,:,:)));
min_z = min(min(Nhist(3,:,:)));
max_z = max(max(Nhist(3,:,:)));

% Get difference between min and max values for each axis
diff_x = max_x-min_x;
diff_y = max_y-min_y;
diff_z = max_z-min_z;

% If values vary in three dimensions, set orthogonal view with
% corresponding min/max axis values
if diff_x>eps && diff_y>eps && diff_z>eps,
	view_vec_derived = [1 1 1];
	axis_vec = [min_x max_x min_y max_y min_z max_z];
	
% If values only vary in two dimensions, set view for 2D plotting
else
	if diff_z < eps,
		view_vec_derived = [0 0 1];
		axis_vec = [min_x max_x min_y max_y];
	elseif diff_y < eps,
		view_vec_derived = [0 1 0];
		axis_vec = [min_x max_x 0 1 min_z max_z];
	elseif diff_x < eps,
		view_vec_derived = [1 0 0];
		axis_vec = [0 1 min_y max_y min_z max_z];
	end
end
view_vec = view_vec_derived;

end