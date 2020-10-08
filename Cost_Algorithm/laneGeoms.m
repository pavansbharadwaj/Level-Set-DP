function [psi_s, ks]= laneGeoms(s, ds, s_fnc)
%Function that calculates the vehicles relation to the whole inertial 
%frame given the sampling interval (in metres).
%
%Input: Sampling interval ds [m], scalar
%Output: psi_s: Tangent angles of path s. Size: [1 x 1/ds].
%        ks: Curvatures of the path s. Size: [1 x 1/ds].

yI=s; %Inertial longitudinal frame, same length as s

%Memory allocations
sx= zeros(1, length(yI)); %x-comp. coordinate of path s. 
sy= zeros(1, length(yI)); %y-comp. coordinate of path s.
dds= zeros(1, length(yI));
oI= [0, 8]; %Origin where the inertial frame is placed.
%Radius
Rx= zeros(1, length(yI));Ry= zeros(1, length(yI));R= zeros(1, length(yI)); 
ks= zeros(1, length(yI)); %Curvatures
psi_s= zeros(1, length(yI)); %Tangent angles

for i=1:length(yI)
    syx= s_fnc(yI(i));
    sx(i)= syx(1); sy(i)= syx(2);
    Rx(i)= sy(i);
    Ry(i)= i*ds; %metres
    R(i)= sqrt(Rx(i) + Ry(i));
    ks(i)=1/R(i);
end

%Calculating the tangent angles
for j=1:length(yI)-1
    dds(j)= (Rx(j+1)-Rx(j))/ds;
    psi_s(j)= 90 + (atan(dds(j))*(180/pi));
end
psi_s(end)=90; %Add last value manually
