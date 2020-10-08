function plotResXY(task, feasSets, grid_x, fcn_laneGeo)

figure; hold on
nStages = task.nStages;
N = numel(task.s);
X = zeros(nStages,2);
Y = zeros(nStages,2);
edge = zeros(nStages,1);

for i = 1:nStages
    S = grid_x(feasSets{i},:); S = S(1,:); % lateral positions
    n = numel(S);
    plot(task.s(N+1-i)*ones(n,1), S, 'b*');
    X(i,:) = [task.s(N+1-i),task.s(N+1-i)];
    Y(i,:) = [min(S), max(S)];
end

for i = 1:N
   edge(i) = fcn_laneGeo(task.s(i)); 
end

plot(edge, task.s, 'k-');
X = reshape(X,nStages*2,1);
Y = reshape(Y,nStages*2.1);
A = alphaShape(X,Y);
plot(A); alpha(0.3);
hold off

end
