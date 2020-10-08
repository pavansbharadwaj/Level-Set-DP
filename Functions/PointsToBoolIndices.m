function indices = PointsToBoolIndices(points, grid_x)

if (size(points,2) ~= 3)
    error('"points" not correct dimension')
end

indices = false(size(grid_x,1),1);
for i = 1:size(points,1)
    [d, index] = FindNearestNeighbours(points(i,:), grid_x);
    indices(index) = true;
end

end