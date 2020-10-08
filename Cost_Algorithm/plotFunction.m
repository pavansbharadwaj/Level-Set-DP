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
    figure(1)
    plot(sy);
    hold on
    ylim([-2 10]);
    figure(3)
    plot(sy);
    hold on
    ylim([-2 10]);
    pathflag=1;
end

%Path plot and cost plot
for step=1:N
    figure(1)
    stateIndices= res(step).feasState;
    states= grid_x(stateIndices, :);
    plot(M-step+1, states(:,1), 'b*', 'markersize', 5);
    %plot(M-step+1, [min(states(:,1)), max(states(:,1))], 'b*',
    %'markersize', 5); %Only plotting outer boundaries
    hold on
    title(['Feasible region as function of d at stage k=', num2str(step)]);
    ylabel('Lateral distance d');xlabel('k');
    grid on
    
    figure(2)
    plot(M-step+1, [res(step).feasCost], 'rx', 'markersize', 5);
    hold on
    title('Costs over time');
    ylabel('J_{sd}');xlabel('k');
    grid on
    
end

%Angle and velocity plot
for step=1:N
    stateIndices= res(step).feasState;
    pos= grid_x(stateIndices,1);
    vels= grid_x(stateIndices,2);
    angs= grid_x(stateIndices,3);
    figure(3)
    for k=1:5:length(pos)
        quiver(100-step, pos(k), vels(k), angs(k), 'r');
        hold on
    end
    xlim([0 100]); ylim([-2 10]);
    title('Feasible vehicle angles and velocities at feasible lateral positions.');
    grid on
    ylabel('Lateral position, d [m]'); xlabel('k (ds=1) [m]');
end