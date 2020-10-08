function [grid_x, grid_u, grid_step] = createGrid(Nx, xMin, xMax, Nu, uMin, uMax)
% Nx, xMin, xMax: dim 3. Nu, uMin, uMax: dim 2.

% states
x1 = linspace(xMin(1), xMax(1), Nx(1));
x2 = linspace(xMin(2), xMax(2), Nx(2));
x3 = linspace(xMin(3), xMax(3), Nx(3));

grid_x_temp = combvec(x2,x3,x1)';

grid_x = zeros(size(grid_x_temp));
grid_x(:,1) = grid_x_temp(:,3); 
grid_x(:,2:3) = grid_x_temp(:,1:2);

% inputs
u1 = linspace(uMin(1), uMax(1), Nu(1));
u2 = linspace(uMin(2), uMax(2), Nu(2));

grid_u = combvec(u1,u2)';

% Just a small bug check
if sum(([x1(1), x2(1), x3(1)] == grid_x(1,1:3))) ~= 3
    error('Grid is not correct')
end

grid_step = [abs(x1(1)- x1(2)), abs(x2(1)-x2(2)), abs(x3(1)-x3(2))];

end