function [] = plotFeasSet(feasSet, k)
% Makes a 2D plot for the feasible set at time step k
% The plotted vector described the heading of a point
% Length describes velocity

N = size(feasSet, 1);
k_vec = ones(N, 1)*k;

plot(k_vec, feasSet(:, 1), 'b.', 'markersize', 7)
hold on
absvel = feasSet(:, 2)./cos(feasSet(:, 3));

[delta_lat, delta_vel] = pol2cart(pi/2+feasSet(:, 3), absvel);
ax = gca;
axpos = get(gca, 'Position');

ax_xlim = get(gca, 'XLim');
ax_ylim = get(gca, 'YLim');
ax_per_xdata = axpos(3) ./ diff(ax_xlim);
ax_per_ydata = axpos(4) ./ diff(ax_ylim);

quiver(k_vec, feasSet(:,1), delta_vel, delta_lat)



title('Heading, absolute velocity and lateral position for time step K')

ylabel('Lateral position [m]')
xlabel('Time step')

end

