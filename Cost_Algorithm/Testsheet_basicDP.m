%Test sheet basic DP
%States are made up of d, vx and gamma (lat. rear axle pos, long.vel.
%heading.

%All state combianations
% df= linspace(0,5,10);
% vxf= linspace(50,0,10);
% gammaf= linspace(-10,30,10);
% %Final input combinations
deltaf= linspace(-10, 10, 20);

Xf_indices= find(TerminalSet==1);

Xf= grid_x(Xf_indices, :);

% Xf= combvec(df, vxf, gammaf, deltaf); %All combinations terminal set and ok steering angle
% Xf_temp=Xf;
% Xf_temp(Xf_temp==0)=0.001;
% Xf=Xf_temp;

%Terminal variables
kappa=0; %path angular rate
Rs=1;   %Radius to inertial fram origin
ks=1/Rs; %Radius constant
L=15;
costs= [];
% for i=1:size(Xf, 2) 
%     costs= [costs; run_cost(kappa, ks, Xf(1,i), Xf(2,i),...
%         Xf(3,i), L, Xf(4,i))]; 
% end
% disp(running_cost)

