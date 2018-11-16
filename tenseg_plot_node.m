function [] = tenseg_plot_node(History,node_ind,axes,line_style)
% TENSEG_PLOT_NODE(History,node_ind,axes,line_style) plots time histories
% of specified axes coordinate values for a given node from a given
% simulation time history. Line style can optionally be specified.
%
% Inputs:
%	History: structure containing [].Nhist obtained from tenseg_sim funciton
%	node_ind: index of node to plot
%	axes (optional): coordinate axes to plot (defaults to [1 2 3])
%	line_style (optional): line plotting style (defaults to 'b')
%
% Example:
%	tenseg_plot_node(hist,1,1:2)


% Handle optional argument inputs
switch nargin
	case 3,
		line_style = 'b';
	case 2,
		line_style = 'b';
		axes = 1:3;
end

if isempty(axes),
	axes = 1:3;
end

number_of_plots = numel(axes);

% Create subplots for each axis
for i=1:number_of_plots,
	subplot(number_of_plots,1,i)
	plot(History.t, squeeze(History.Nhist(axes(i),node_ind,:))',line_style,'LineWidth',2)
	hold on
	if axes(i)==1,
		ylabel('x')
	elseif axes(i)==2,
		ylabel('y')
	elseif axes(i)==3,
		ylabel('z')
	end
end
xlabel('Time')

end