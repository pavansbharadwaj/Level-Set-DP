function [d, dIndex] = FindNearestNeighbours(point, grid_x)
% Returns the index and distance to the closest gridpoint

%[d, dIndex] = min(sqrt(sum((point-grid_x).^2, 2)));
[d, dIndex] = min(vecnorm(point-grid_x, 2, 2));
 
end
