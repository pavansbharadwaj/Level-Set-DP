function [idxMin, idxMax] = cut_off_grid_latPos(grid_x, dyMax, yMinFeas, yMaxFeas)

yMin = yMinFeas-dyMax;
yMax = yMaxFeas+dyMax;

idxMin = find(grid_x(:,1)>=yMin, 1,'first');
idxMax = find(grid_x(:,1)<=yMax, 1,'last');

end