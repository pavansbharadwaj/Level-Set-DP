function [sidePoints] = calcBusPos(xPos, yPos, gamma, busBox, numPoints)
% busBox contains four corners of the bus as a 2x4 matrix
% gamma is the heading angle of the bus
% xPos is the longitudinal position of the center of the bus
% yPos is the lateral position of the center of the bus


rotMatrix = [cos(gamma), -sin(gamma)
            sin(gamma) cos(gamma)];

sidePointsLeft = zeros(2, numPoints);
sidePointsRight = zeros(2, numPoints);

sidePointsLeft(1, :) = linspace(min(busBox(1,:)), max(busBox(1,:)), numPoints);
sidePointsLeft(2, :) = max(busBox(2,:));

sidePointsRight(1, :) = linspace(min(busBox(1,:)), max(busBox(1,:)), numPoints);
sidePointsRight(2, :) = min(busBox(2,:));

sidePoints = [sidePointsLeft sidePointsRight];

sidePoints = rotMatrix * sidePoints;

sidePoints = sidePoints + [xPos; yPos];
        
% To visualize and debug
% plot(sidePoints(1,:), sidePoints(2,:), '.')
% hold on
% axis equal

end

