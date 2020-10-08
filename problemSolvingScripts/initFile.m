task.nStages = numel(task.s);     % number of samples
s = task.s;                         %[m] vector of samples
task.ds = s(2) - s(1);              %[m] sampling interval
sf = s(end);                        %[m] length of horizon

L = V.frontaxlepos - V.rearaxlepos;
Lf = V.length - V.rearaxlepos;
Lr = -V.rearaxlepos;
B = V.width/2;  % [m] Half width of the vehicle

% create anonymous function for approximate bus stop geometry
c = 1;
task.fcn_laneGeo=@(x) [-task.lanewidth/2; ...
    task.busstopwidth./(1+exp(-c*(x - task.busstopedgepos))) + task.lanewidth/2];

% actual busstop geometry
%task.busstopgeometry = task.lanewidth/2*ones(task.nStages,1);
%task.busstopgeometry(task.s > task.busstopedgepos) = task.lanewidth/2 + task.busstopwidth;


% Grids and terminal set

xMin = [min(-task.lanewidth/2*ones(task.nStages+1,1))+V.width/2, task.vmin, task.yawmin];
xMax = [max(task.fcn_laneGeo(s))-V.width/2, task.vmax, task.yawmax];
uMin = [task.axmin, task.deltamin];
uMax = [task.axmax, task.deltamax];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% DEBUG ROWS
% xMin(1) = 3.6;
% xMin(3) = -3*pi/180;
% xMax(3) = 3*pi/180;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[grid_x, grid_u, grid_step] = createGrid(task.Nx, xMin, xMax,...
    task.Nu, uMin, uMax);

grid_x = FilterGridPoints(grid_x, V.busbox, task.fcn_laneGeo);

xfMin = [3.6, 0.000001, -2*pi/180];
xfMax = [3.725, 0.3, 2*pi/180];

TerminalSet = createTerminalSet(grid_x, xfMin, xfMax);

display(['Sum(TerminalSet)'])
sum(TerminalSet)   % DELETE

