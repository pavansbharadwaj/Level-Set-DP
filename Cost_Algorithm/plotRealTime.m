pathflag=task.pathflag;
if ~pathflag %Plots the path once
    yI= task.s;
    M= length(yI);
    N= size(res, 2);
    sy=zeros(1,size(yI,2));
    s_fnc= task.fcn_laneGeo;
    for i=1:length(yI)
        syx= s_fnc(yI(i));
        sy(i)= syx(2);
    end
    %Lateral pos plot
    figure(1)
    plot(sy);
    hold on
    ylim([-2 10]);
    title(['Feasible region as function of d at stage k=', num2str(step)]);
    ylabel('Lateral distance d');xlabel('k');
    grid on
    %Cost plot
    figure(2)
    title('Costs over time');
    ylabel('J_{sd}');xlabel('k');
    grid on
    %Angle and velocity plot
    figure(3)
    plot(sy);
    hold on
    ylim([-2 10]);
    title('Feasible vehicle angles and velocities at feasible lateral positions.');
    grid on
    ylabel('Lateral position, d [m]'); xlabel('k (ds=1) [m]');
  
    task.pathflag=1;
end

%Running path plot
stateIndices= res(step).feasState;
pos= grid_x(stateIndices,1);
states= grid_x(stateIndices, :);
figure(1)
%plot(M-step+1, states(:,1), 'b*', 'markersize', 5); %plot all points
plot(M-step+1, [min(pos), max(pos)], 'b*', 'markersize', 5); %plot boundaries
hold on

%Running cost plot
figure(2)
plot(M-step+1, [res(step).feasCost], 'rx', 'markersize', 5);
hold on

%Running angle and velocity plot
vels= grid_x(stateIndices,2);
angs= grid_x(stateIndices,3);

figure(3) %Fix exception for when plotting boundaries
for k=1:5:length(pos) %Only plotting every 5th state for clarity
    quiver(100-step, pos(k), vels(k), angs(k), 'r');
    hold on
end
