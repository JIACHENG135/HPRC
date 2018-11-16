% function s_0_seg = tenseg_s0_segment( N,C_s,s_0,parents )
% MAYBE OBSOLETE?
%
% alpha = size(C_s,1);
% S = N*C_s';
% percents = zeros(1,alpha);
% for i=1:alpha,
% 	percents(i) = s_0(i)/norm(S(:,i));
% end
% 
% percent_input = [(1:alpha)', percents'];
% s_0_seg = tenseg_percent2s0(N,C_s,percent_input,parents);
% 
% end
% 
