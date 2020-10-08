clearvars; clc; close all

%Create structure for the task
task = struct;
task.usesidepoints = true;
task.softconstraints = false;       % whether to use soft constraints for the states
%task.plotres = true;                % plot results
%task.animateres = true;             % animate results
task.s = linspace(1,100,100)';      %[m] vector of positions about which sampling is performed
task.busstopedgepos = 60;           %[m] position at which the busstop starts
task.lanewidth = 4;                 %[m] width of the road lane
task.busstopwidth = 3;              %[m] width of the busstop outside the lane
task.finalsidedistance = 0.05;      %[m] final distance from busstop side
task.axmin =-0.2;                   %[m/s2] minimum longitudinal acceleration
task.axmax = 0.2;                   %[m/s2] maximum longitudinal acceleration
task.vmin = 0.0000001/3.6;          %[m/s] minimum speed
task.vmax = 45/3.6;                 %[m/s] maximum speed   
task.deltamin =-30*pi/180;          %[rad] minimum steering angle
task.deltamax = 30*pi/180;          %[rad] maximum steering angle
task.yawmin =-45*pi/180;            %[rad] minimum yaw angle
task.yawmax = 45*pi/180;            %[rad] maximum yaw angle

task.Sangle = 1;                    % Scaling factor for angles
task.numsidepoints = 4;             % number of side points for geometric constraints
task.pathflag=0;
%Resolution for each variable
task.Nx = [71,51,31];
task.Nu = [11,61];
% task.Nx = [61, 41, 21];
% task.Nu = [11, 51];

% Create the vehicle object
V = Volvo7900;
V.width = 2.55;                     %[m] vehicle width
V.rearaxlepos = 3.485;              %[m] length from rear edge to rear wheels axle
V.frontaxlepos = 5.945 + 3.485;     %[m] length from rear edge to front wheels axle 
V.length = V.frontaxlepos + 2.704;  %[m] total length 
V.busbox = [-V.length/2, V.length/2, V.length/2, -V.length/2;
            V.width/2, V.width/2, -V.width/2, -V.width/2];

% Create structure for results
task.res = struct;

% prethreat data
initFile;

% solve the problem (results plotted real-time)
draftCostAlgorithm;
