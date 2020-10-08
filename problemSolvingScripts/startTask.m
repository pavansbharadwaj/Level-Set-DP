% addpath(fullfile(pwd,'\..\casadi-windows-matlabR2016a-v3.5.1'))
% addpath(fullfile(pwd,'\..\Functions'))
addpath('C:\Users\marti\OneDrive\Dokument\casadi_3_4_5')
clearvars; clc;

% Create structure for the task
task = struct;
task.usesidepoints = true;
task.softconstraints = false;       % whether to use soft constraints for the states
task.plotres = true;                % plot results
task.animateres = true;             % animate results
%task.steeringpenalty = 1*1e-0;      % penalty on steering anlge
%task.steeringratepenalty = 1*1e2;   % penalty on steering rate
%task.lataccpenalty = 1*1e-2;        % penalty on lateral acceleration
%task.longaccpenalty = 1*1e-2;       % penalty on longitudinal acceleration
%task.longjerkpenalty = 1*1e-0;      % penalty on longitudinal jerk
%task.timepenalty = 1e-2;            % penalty on travel time
%task.finalpositionpenalty = 1e3;    % penalty for deviation from target lateral position
%task.finaloritentationpenalty = 5e3;% penalty for deviation from target yaw angle
task.s = linspace(99,100,2)';      %[m] vector of positions about which sampling is performed
task.busstopedgepos = 60;           %[m] position at which the busstop starts
task.lanewidth = 4;                 %[m] width of the road lane
task.busstopwidth = 3;              %[m] width of the busstop outside the lane
task.finalsidedistance = 0.05;      %[m] final distance from busstop side
%task.jxmax = 1;                     %[m/s3] maximum longitudinal jerk
task.axmin =-0.2;                     %[m/s2] minimum longitudinal acceleration
task.axmax = 0.2;                     %[m/s2] maximum longitudinal acceleration
%task.aymax = 1;                     %[m/s2] maximum lateral acceleration
task.vmin = 0.0000001/3.6;                  %[m/s] minimum speed
task.vmax = 45/3.6;                 %[m/s] maximum speed   
task.deltamin =-30*pi/180;          %[rad] minimum steering angle
task.deltamax = 30*pi/180;          %[rad] maximum steering angle
task.yawmin =-45*pi/180;            %[rad] minimum yaw angle
task.yawmax = 45*pi/180;            %[rad] maximum yaw angle

task.Sangle = 1;                    % Scaling factor for angles
task.numsidepoints = 4;             % number of side points for geometric constraints
task.Nx = [500,100,271];
task.Nu = [20,201];

% Create the vehicle object
V = Volvo7900;
V.width = 2.55;                     %[m] vehicle width
V.rearaxlepos = 3.485;              %[m] length from rear edge to rear wheels axle
V.frontaxlepos = 5.945 + 3.485;     %[m] length from rear edge to front wheels axle 
V.length = V.frontaxlepos + 2.704;  %[m] total length 
V.busbox = [-V.length/2, V.length/2, V.length/2, -V.length/2;
            V.width/2, V.width/2, -V.width/2, -V.width/2];

% Create structure for results
% res = struct;

% prethreat data
initFile;

% solve the problem
Draft_algorithm;
% task.res = res;

% plot results
% -> plotFunction
