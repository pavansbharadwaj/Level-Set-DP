% Draft - Cost function algorithm

% Parameters
%nStages = task.nStages; % Number of samples
ds = task.ds;           %[m] sampling interval
s = task.s;             %[m] path about which sampling is performed
Sa = task.Sangle;       % scaling factor for angles
res= task.res;          %Results

%Bus dimensions
%L = V.frontaxlepos - V.rearaxlepos;
Lf = V.length - V.rearaxlepos;
Lr = -V.rearaxlepos;
B = V.width/2;  % [m] Half width of the vehicle
L=15;

%Resolutions state and input variables
Nx = task.Nx;
Nu = task.Nu;

%Lane geometries
s_func= task.fcn_laneGeo;
[psi_s, ks]= laneGeoms(s, ds, s_func);

%Terminal variables
kappaf = (psi_s(end) - psi_s(end-1))/ds;
ksf=ks(end);

%%%%%%%%%%%%%%%%% TERMINAL SET %%%%%%%%%%%%%%%%%
%Allocations terminal cost
terminalCosts= []; feasInputIdx= []; feasInputCost= [];

%Finding and "trimming" terminal set. (Avoiding division by 0)
Xf_indices= find(TerminalSet==1);
Xf= grid_x(Xf_indices, :);
Xf_temp= Xf;
Xf_temp(Xf_temp==0)=10e-5;
Xf= Xf_temp;

%Final input combinations (steering wheel angle, slip neglected)
deltaf= linspace(-10*pi/180, 10*pi/180, task.Nu(2));

%Defining terminal cost
for i=1:size(Xf,1)
    for j=1:length(deltaf)
        terminalCosts = [terminalCosts; run_cost(kappaf, ksf, Xf(i,1),...
            Xf(i,2), Xf(i,3), L, deltaf(i))];
    end
end
res(1).feasState= Xf_indices;
terminalCosts= round(terminalCosts, 4);
res(1).feasCost= terminalCosts;
res(1).feasInput= deltaf; %The only time input isn't an index
% The only time input isn't an index
%%%%%%%%%%%%%%%%% END OF TERMINAL SET DEF %%%%%%%%%%%%%%%%%

nStages = 50;
t=0.001;
dyMax = ds; %Maximum of longitudinal change possible
longPos = task.s(end);

%%%%%%%%%%%%%%%%% DP ALGORITHM %%%%%%%%%%%%%%%%%
for step = 2:nStages-1
    longPos = longPos - ds; 
    minStageCosts=[]; optInputIdxSet=[]; currentState=[]; feasStateIdx=[];
    prev_set_idx= res(step-1).feasState;
    prev_set= grid_x(prev_set_idx,:);
    kappa= (psi_s(step+1) - psi_s(step))/ds;
    %Sort for d
    yMinFeas = min(prev_set(:,1));
    yMaxFeas = max(prev_set(:,1));
    
    [idxMin, idxMax] = cut_off_grid_latPos(grid_x, dyMax, yMinFeas, yMaxFeas);
    
    for i_x = idxMin:idxMax
        feasInputCost=[]; feasInput=[]; Xm = zeros(size(grid_u,1),3);
        latPos = grid_x(i_x, 1);    % latitude position
        angle = grid_x(i_x, 3);     % gamma
        
        %Checking if bus is in lane
        sidePoints = calcBusPos(longPos, latPos, angle, V.busbox, task.numsidepoints);
        isInLane = checkWithinLane(sidePoints, task.fcn_laneGeo);
        
         if isInLane %If bus is in lane, proceed to calculate costs
            for i_u = 1:size(grid_u,1) % loop over all input grid indices
                
                %dynamics (according to ebbesen-paper)
                fx = (1-latPos*ks(end-step))/(grid_x(i_x,2)*cos(angle))*[tan(angle);
                      grid_u(i_u,1) / grid_x(i_x,2) / cos(angle);
                      tan(grid_u(i_u,2)) / L / cos(angle) / Sa;]; 

                %x_tilde(k+1), one step with dynamics 
                Xm(i_u,:) = grid_x(i_x,:) + ds*fx';              
                
                %Check if Xm is feasible
                 [newCost, feasible] = checkFeasibleCost(Xm(i_u,:),...
                     res(step-1).feasCost, step, L, grid_u(i_u,:), kappa, ks, t);

                if feasible
                    %Save feasible input index
                    feasInputIdx = [feasInputIdx; i_u];
                    
                    %Save feasible cost
                    feasInputCost= [feasInputCost; newCost];                
                end
            end
            %Feasability found, save input and state indices, cost numerics
            if ~isempty(feasInputCost)
                minCostIdx= find(feasInputCost == min(feasInputCost));
                minCost= feasInputCost(minCostIdx);
                optInputIdx= feasInputIdx(minCostIdx);
                optInputIdxSet= [optInputIdxSet; optInputIdx];
                feasStateIdx= [feasStateIdx; i_x];
                minStageCosts= [minStageCosts; minCost];
            end
         end     
    end
    %Display metrics
    disp(['Stage: ', num2str(step)]);
    
    %Add feasible states, inputs and costs to main struct
    res(step).feasInput= optInputIdxSet;
    res(step).feasState= feasStateIdx;
    minStageCosts= round(minStageCosts, 4);
    res(step).feasCost= minStageCosts;
    plotFunction; %Real time plotting
end

