function running_cost= run_cost(kappa, ks, d, vx, gamma, L, delta)
%Running cost function J=t'(s)+d'(s)+gamma'(s)

running_cost = ((1-kappa*d)/(vx*cos(gamma))) + ((1 - ks*d)*tan(gamma)) +...
    ((tan(delta)/L)*((1-ks*d)/cos(gamma))-kappa);
