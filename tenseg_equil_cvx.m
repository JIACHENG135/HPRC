function [s_0_equil,gamma_equil,s_0_percent] = tenseg_equil_cvx(tenseg_struct, s_0_percent_assign)
% [s_0_equil,gamma_equil,s_0_percent] =
% TENSEG_EQUIL(tenseg_struct,s_0_percent_assign) numerically solves for
% equilibrium conditions for a given tensegrity structure. This is done
% numerically assuming the given strings have given resting percent
% lengths. Based on the resulting gamma equilibrium values, resting string
% lengths are found based on the known string lenghts and stiffnesses.
%
% Inputs:
%	tenseg_struct:
%		[].N: node matrix
%		[].C_b: bar connectivity matrix
%		[].C_s: string connectivity matrix
%		(optional) [].W: external force matrix
%		(optional) [].k: string stiffness coefficients
%	s_0_percent_assign: string indices and prescribed resting string
%		lengths percentages (< 1).
%		Ex: s_0_percent_assign = [string_inds, percent_vals]
%
% Outputs:
%	s_0_equil: equilibrium string rest lengths
%	gamma_equil: equilibrium string force densities
%	s_0_percent: equilibrium string rest lengths (as percentage of length)
%
% Example:
%	s_0_equil = tenseg_equil_cvx(prism, [1 0.7]);


if nargin < 2,
	s_0_percent_assign = []; % Default to no assigned string lengths
end

% Load in structure definitions
N = tenseg_struct.N;
C_s = tenseg_struct.C_s;
C_b = tenseg_struct.C_b;

tenseg_struct = tenseg_convert_Cmats(tenseg_struct);
C_bb = tenseg_struct.C_bb;
C_sb = tenseg_struct.C_sb;
C_ss = tenseg_struct.C_ss;
C_nb = tenseg_struct.C_nb;

% Get basic structure values
n = size(N,2); % number of nodes
beta = size(C_b,1); % number of bars
alpha = size(C_s,1); % number of strings
sigma = n-2*beta; % Number of string nodes
default = tenseg_defaults(n,beta,alpha,sigma);

% Load specified or default external forces and string stiffnesses
tenseg_struct = tenseg_field_init('W',tenseg_struct,tenseg_struct,default,0); % External forces acting on each node
tenseg_struct = tenseg_field_init('k',tenseg_struct,tenseg_struct,default,0); % String stiffness coefficients
tenseg_struct = tenseg_field_init('pinned_nodes',tenseg_struct,tenseg_struct,default,0);
tenseg_struct = tenseg_field_init('P',tenseg_struct,tenseg_struct,default,0);

W = tenseg_struct.W;
k = tenseg_struct.k';
pinned_nodes = tenseg_struct.pinned_nodes;
P = tenseg_struct.P;
constraints = size(P,2);
if ~constraints,
	P = 0;
end

s_len = diag(sqrt(diag(diag(C_s*(N'*N)*C_s'))));

% If there are assigned rest length percentages, convert them to gamma vals
if ~isempty(s_0_percent_assign),
	assigned_ind = s_0_percent_assign(:,1);
	assigned = numel(assigned_ind);
	assigned_percents = s_0_percent_assign(:,2);
	assigned_s_0 = s_len(assigned_ind).*assigned_percents;
	gamma_assign_vals = k(assigned_ind).*(1-assigned_s_0./s_len(assigned_ind)); % gamma = k*(1-s_0/length)
else
	assigned = 0;
end

% Set up CVX task to numerically solve for gamma values satisfying equilibrium
if constraints % if there are constraints, we need to include Omega as an unknown
	cvx_begin

		% Define unknowns
		variable gama(alpha) nonnegative
		variable Omega(3,constraints)

		gamma_hat = diag(gama);
		F = W + Omega*P' - N*C_s'*gamma_hat*C_s;
		len_hat = sqrt(diag(diag(C_b*(N'*N)*C_b')));
		lambda_hat = -1/2*diag(diag(C_b*N'*F*C_b'))*len_hat^-2;
		K = [C_s'*gamma_hat*C_sb - C_nb'*C_bb'*lambda_hat*C_bb, C_s'*gamma_hat*C_ss];

		% Set optimization goal
		minimize(norm(gama))
		subject to
			abs(N*K-W-Omega*P') <= 10*eps*ones(size(W))

		% Add additional constraints
		if assigned > 0,
			subject to
				abs(gama(assigned_ind)-gamma_assign_vals) <= 10*eps*ones(assigned,1)
		end
	cvx_end
else
	cvx_begin

		% Define unknowns
		variable gama(alpha) nonnegative

		gamma_hat = diag(gama);
		F = W - N*C_s'*gamma_hat*C_s;
		len_hat = sqrt(diag(diag(C_b*(N'*N)*C_b')));
		lambda_hat = -1/2*diag(diag(C_b*N'*F*C_b'))*len_hat^-2;

		K = [C_s'*gamma_hat*C_sb - C_nb'*C_bb'*lambda_hat*C_bb, C_s'*gamma_hat*C_ss];

		% Specify optimization task
		minimize(norm(gama))
		subject to
			abs(N*K-W) <= 10*eps*ones(size(N*K-W))

		% Add additional constraints
		if assigned > 0,
			subject to
				abs(gama(assigned_ind)-gamma_assign_vals) <= 10*eps*ones(assigned,1)
		end
	cvx_end
end

gamma_equil = gama;

% Get resting string lengths from equilibrium gamma values found
s_0_equil = s_len.*(1-gamma_equil./k); %s_0 = length*(1-gamma/k)
s_0_percent = s_0_equil./s_len;
	

end