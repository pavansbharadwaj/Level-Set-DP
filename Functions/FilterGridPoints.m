function [grid_x] = FilterGridPoints(grid_x, busBox, fcn_laneGeo)
% Check if grid points fulfill the geometric constraints.

xPos = 100;
numPoints = 10;
indicesToRemove = [];
for k = 1:size(grid_x, 1)
    yPos = grid_x(k, 1);
    gamma = grid_x(k, 3);
    sidePoints = calcBusPos(xPos, yPos, gamma, busBox, numPoints);
    inLane = checkWithinLane(sidePoints, fcn_laneGeo);

    if ~inLane
        indicesToRemove = [indicesToRemove k];
    end

end

grid_x(indicesToRemove, :) = [];

end

