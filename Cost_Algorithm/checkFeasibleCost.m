function [newCost, feasible]= checkFeasibleCost(Xm, cost, stage, L, delta, kappa, k_s, t)
ks= k_s(stage);

d = Xm(1); vx = Xm(2); gamma= Xm(3);

new_cost= ((1-kappa*d)/(vx*cos(gamma))) + ((1 - ks*d)*tan(gamma)) +...
   ((tan(delta(2))/L)*((1-ks*d)/cos(gamma))-kappa);

[~, ixx] = min(abs(round(cost,4)-new_cost));

if abs(cost(ixx)-round(new_cost,4)) <= t
    newCost = round(new_cost,4);
    feasible= true;
else
    newCost = round(new_cost,4);
    feasible= false; 
end


