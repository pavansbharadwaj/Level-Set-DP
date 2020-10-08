%function [psi_s, ks]= laneGeomTest(s)

ds= 0.001; %Sampling interval of path s (given as input)

%y=linspace(0,50,1/s);
yI= linspace(0,100,1/ds); %samples in longitudinal direction
xI= zeros(1, length(yI)); %samples in lateral direction
sx= zeros(1, length(yI)); %x-comp. coordinate of path s 
sy= zeros(1, length(yI)); %y-comp. coordinate of path s
oI= [0, 8];

R= zeros(1, length(yI));
ks= zeros(1, length(yI));
psi_s= zeros(1, length(yI));

% c = 1;
% task.fcn_laneGeo=@(x) [-task.lanewidth/2; ...
%     task.busstopwidth./(1+exp(-c*(x - task.busstopedgepos))) + task.lanewidth/2];

%Function for the lane s
sfnc= task.fcn_laneGeo;

for i=1:length(yI)
    syx= sfnc(yI(i));
    sx(i)= syx(1); sy(i)= syx(2);
    Rx(i)= sy(i);
    Ry(i)= i/10; %m
    R(i)= sqrt(Rx(i) + Ry(i));
    ks(i)=1/R(i);
end

%Calculating the tangent angles
for j=1:length(yI)-1
    dds(j)= (Rx(j+1)-Rx(j))/ds;
    psi_s(j)= 90 + (atan(dds(j))*(180/pi));
end

figure()
title('Inertial frame position, path s and radius');
plot(sy)
hold on
plot(oI(1), oI(2), '*', 'markersize', 10); %origo
hold on
plot([oI(1), Ry(590)*10], [oI(2), Rx(590)]);
legend('Reference path s', 'Intertial fram origin', 'Radius');
ylim([-2 10]); xlim([0 1000]);
ylabel('lateral position x');xlabel('longitudinal position y');


% old code
% for i=1:length(y)
%     if (0 <= y(i) ) && ( y(i) <= 10)
%         x(i)=3;
%         psi_s(i)=90;
%     elseif (y(i) > 10) && (y(i) <= 25)
%         x(i)= (y(i)-25)/-5;
%         psi_s(i) = 90+(atan(0.2)*(180/pi));
%     else
%         x(i)=0;
%         psi_s(i) = 90;
%     end
%     R(i)= sqrt(x(i)^2 + y(i)^2);
%     ks(i)= 1/R(i); 
% end
