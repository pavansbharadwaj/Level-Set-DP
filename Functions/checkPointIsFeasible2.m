function isFeas = checkPointIsFeasible2(points, feas_points, grid_step)

dim = size(points,2);

[indices, dists] = knnsearch(feas_points, points);
[~, idx] = min(dists);
isFeas = logical( sum( abs(feas_points(indices(idx),:)-points(idx)) <= grid_step) == dim);

end

