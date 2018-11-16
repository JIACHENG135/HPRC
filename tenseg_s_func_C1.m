function tenseg_s_func_C1(block)

% Generate full sim task data structure from inputs
task = evalin('base','task');
info = tenseg_struct_gen(task);

% Get and log time span info
dt = info.sim.dt;
tf = info.sim.tf;
t = 0:dt:tf;
info.sim.tspan = t;

n = info.constants.n;

global X0 INPUTS

% ODE4 METHOD -------------------
% Reshape initial N, Nd matrices into vector format for ode function
XN0 = reshape(info.ICs.N0,3*n,1);
XNd0 = reshape(info.ICs.Nd0,3*n,1);
X0 = [XN0; XNd0];

% Store structure information to INPUTS to send to ode function
INPUTS.ICs = info.ICs;
INPUTS.tenseg_struct = info.sys_def;
INPUTS.forces = info.forces;
INPUTS.constants = info.constants;
INPUTS.sim = info.sim;


  setup(block,INPUTS);
  
%endfunction

function setup(block,INPUTS)
  
  %% Register number of dialog parameters   
  block.NumDialogPrms = 0;

  %% Register number of input and output ports
  block.NumInputPorts  = 1;
  block.NumOutputPorts = 1;

  %% Setup functional port properties to dynamically
  %% inherited.
  block.SetPreCompInpPortInfoToDynamic;
  block.SetPreCompOutPortInfoToDynamic;
 
  block.InputPort(1).Dimensions        = size(INPUTS.tenseg_struct.C_s,1); % NUMBER OF INPUT STATES (S_0)
  block.InputPort(1).DirectFeedthrough = false;
  
  block.OutputPort(1).Dimensions       = 2*numel(INPUTS.ICs.N0); % NUMBER OF OUTPUT STATES
  
  
  %% Set block sample time to continuous
  block.SampleTimes = [0 0];
  
  %% Setup Dwork
  block.NumContStates = 2*numel(INPUTS.ICs.N0); % NUMBER OF SYSTEM STATES

  %% Set the block simStateCompliance to default (i.e., same as a built-in block)
  block.SimStateCompliance = 'DefaultSimState';

  %% Register methods
  block.RegBlockMethod('InitializeConditions',    @InitConditions);  
  block.RegBlockMethod('Outputs',                 @Output);  
  block.RegBlockMethod('Derivatives',             @Derivative);  
  
%endfunction

function InitConditions(block)

  %% Initialize Dwork
  global X0
  block.ContStates.Data = X0; % WHERE TO GET ICs FOR STATES
  
%endfunction

function Output(block)

block.OutputPort(1).Data = block.ContStates.Data;
  
%endfunction

function Derivative(block)

	global INPUTS

	% READ IN PARAMETERS
	
	t = block.CurrentTime;
	X = block.ContStates.Data;

	INPUTS.forces.s_0 = block.InputPort(1).Data;
	Xd = tenseg_dyn_c1open_fnc( t,X,INPUTS );
	block.Derivatives.Data = Xd;
  
%endfunction

