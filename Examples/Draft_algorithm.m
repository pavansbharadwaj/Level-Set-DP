% Parameters
nStages = task.nStages; % Number of samples
ds = task.ds;           %[m] sampling interval
s = task.s;             %[m] path about which sampling is performed
%M = 1;                  % number of state intervals per stage 
%dt = ds/M;              % sampling interval of states per stage
Sa = task.Sangle;       % scaling factor for angles

L = V.frontaxlepos - V.rearaxlepos;
Lf = V.length - V.rearaxlepos;
Lr = -V.rearaxlepos;
B = V.width/2;  % [m] Half width of the vehicle

Nx = task.Nx;
Nu = task.Nu;

% % MinMaxVals = struct;
% % MinMaxVals.d = [-task.lanewidth/2*ones(N+1,1),...
% %     task.fcn_busstopgeometry(s)];     % min, max lateral position
% % MinMaxVals.vx = [task.vmin, task.vmax;];
% % MinMaxVals.gamma = [task.yawmin, task.yawmax;];
% 
% % Define states and controls
% xLabels = {'d', 'vx', 'gamma'};                     % states
% xStages = {1:nStages+1,1:nStages+1,1:nStages+1};   % stages for the states
% uLabels = {'ax','delta'};                           % control inputs
% uStages = {1:nStages, 1:nStages};                   % stages for the control inputs
% 
% nx = numel(xLabels);                % number of states
% nu = numel(uLabels);                % number of control inputs
% 
% % Create structures with indices. Structure ix, iu, is, ip, will store
% % the index of a particular state, control input, slack variable and
% % paremeter, respectively, in their respective list of labels.
% ix=struct; 
% for j=1:nx
%     ix.(xLabels{j})=j;
% end
% iu=struct; 
% for j=1:nu
%     iu.(uLabels{j})=j;
% end
% 
% % Create dynamics
% x = casadi.SX.sym('x', nx, 1);  % symbolic variables for states
% u = casadi.SX.sym('u', nu, 1);  % symbolic variables for control inputs
% 
% vx = x(ix.vx);
% gamma = x(ix.gamma)*Sa;
% ax = u(iu.ax);
% delta = u(iu.delta)*Sa;
% 
% dynamics = [tan(gamma);
%             ax / vx / cos(gamma);
%             tan(delta) / L / cos(gamma) / Sa;
%             ];
% 
% f = casadi.Function('f', {x, u}, {dynamics});

% Compute the backward feasible sets
nGridPoints = size(grid_x,1);
feasSets = {TerminalSet}; % <==== ToDo: define TerminalSet

sumIsInLane = 0;   % DELETE
sumIsInFeasSet = 0; % DELETE

longPos = task.s(end);

grid_step_dist = norm(grid_step)/2;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% DEBUG TESTING %%%%%%%%%%%%%%%%%%%%%%
nStages = 5;
dyMax = ds;
step_size = grid_step;
for step = 2:nStages
    longPos = longPos - ds;     % update longitudal position
    feas_xs = false(nGridPoints,1);
    temp_set = grid_x(feasSets{step-1}, :);
    yMinFeas = min(temp_set(:,1));
    yMaxFeas = max(temp_set(:,1));
    
    [idxMin, idxMax] = cut_off_grid_latPos(grid_x, dyMax, yMinFeas, yMaxFeas)
    
    for i_x = idxMin:idxMax  % loop over all state grid indices
        
        latPos = grid_x(i_x, 1);    % latitude position
        angle = grid_x(i_x, 3);     % gamma
        
        sidePoints = calcBusPos(longPos, latPos, angle, V.busbox, task.numsidepoints);
        isInLane = checkWithinLane(sidePoints, task.fcn_laneGeo);
        if isInLane
            sumIsInLane = sumIsInLane + 1; % DELETE
            Xm = zeros(size(grid_u,1),3);
            for i_u = 1:size(grid_u,1) % loop over all input grid indices
                % Take step with dynamics

                fx = [tan(angle)
                      grid_u(i_u,1) / grid_x(i_x,2) / cos(angle) 
                      tan(grid_u(i_u,2)) / L / cos(angle) / Sa];
                Xm(i_u,:) = grid_x(i_x,:) + ds*fx'; 
            end
            isInFeasSet = checkPointIsFeasible(Xm, temp_set, grid_step);
            if isInFeasSet
                sumIsInFeasSet = sumIsInFeasSet + 1; % DELETE
                feas_xs(i_x) = true;
                % grid_u(i_u,:) % DELETE
            end 
        end
        
    end
    
    feasSets{step} = feas_xs;
end

for k = 1:length(feasSets)
   plotFeasSet(grid_x(feasSets{k}, :), k) 
end

% shp = grid_x(logical(feasSets{1}),:);
% plot(alphaShape(shp(:,1),shp(:,2),shp(:,3))); hold on
% 
% shp = grid_x(logical(feasSets{2}),:);
% plot(alphaShape(shp(:,1),shp(:,2),shp(:,3)), 'FaceColor', 'r');


