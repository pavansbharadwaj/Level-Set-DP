function [feasible] = checkWithinLane(sidePoints, fcn_laneGeo)
%With given sidepoints, check if these are within the lane
% 
% fcn_laneGeo=@(x) [-lanewidth/2  ...
%     busstopwidth./(1+exp(-c*(x - busstopedgepos))) + lanewidth/2];

feasible = true;

for k = 1:size(sidePoints, 2)

    yLimit = fcn_laneGeo(sidePoints(1, k));

    if 10^-10>(yLimit(2)-sidePoints(2,k)) | sidePoints(2, k) < yLimit(1)
       feasible = false; 
       return
    end
    
    
end
    
end

