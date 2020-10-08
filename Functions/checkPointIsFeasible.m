function [isFeas] = checkPointIsFeasible(points, feas_points, grid_step)

isFeas = false;

nDim = size(points, 2);
nPoints = size(points, 1);

for k = 1:nPoints
    point_dist = abs(feas_points-points(k, :));
    if max(sum(point_dist <= grid_step./2, 2)) == nDim    
       isFeas = 1;
       return
    end
end



end