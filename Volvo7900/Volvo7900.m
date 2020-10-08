classdef Volvo7900 < matlab.mixin.Copyable 
% Generic vehicle implemented as a copyable handle class. 
% x is state vector:  
%   x(1) = x_I:         [m] longitudinal position of CoG in inertial frame
%   x(2) = y_I:         [m] lateral position of CoG in inertial frame
%   x(3) = psi_V:       [rad] yaw angle (heading)
%   x(4) = delta:       [rad] steering angle
%   x(5) = dot x_V:     [m/s] longitudinal velocity of CoG in vehicle frame
%   x(6) = dot y_V:     [m/s] = lateral velocity of CoG in vehicle frame
%   x(7) = dot psi_V:   [rad/s] yaw rate

properties
    width=1.78;                     %[m] vehicle width
    length=4.27;                    %[m] vehicle length
    mass=1700;                      %[kg] total mass
    wheelradius=1;                  %[m] wheel radius
    frontwheelspos=zeros(2,2);      %[m] front wheels position
    rearaxlepos=3.485;              %[m] position of rear axle from the rear
    frontaxlepos=9.43;              %[m] position of front axle from the rear
    hgtfrontwheels=[];              %[hgtransform] hgtransform objects for the front wheels.    
    hgt=[];                         %[hgtransform] hgtransform object of the vehicle.
    color='b';                      % chassis color
    facealpha=0.7;                  % transparency
    x;                              % state vector.
    busbox;
end

methods
     % constructor
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function obj = Volvo7900()  
        obj.width=2.55;                 %[m] vehicle width
        obj.length=12.134;              %[m] vehicle length
        obj.mass=15e3;                  %[kg] total mass
        obj.x=zeros(7,1);               
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function plot(obj)
    % Plots the vehicle chassis.
        if isempty(obj.hgt) || ~ishghandle(obj.hgt,'hgtransform')
            obj.hgt=hgtransform;
            obj.hgtfrontwheels=[hgtransform('Parent',obj.hgt); ...
                                hgtransform('Parent',obj.hgt)];
                        
            w=350;                  % original width of the scaled vehicle in the image
            len=1630;               % original height of the scaled vehicle in the image
            R = (1327 - 1196)/2;    % wheel radius
            sx=obj.length/len;      % longitudinal scaling
            sy=obj.width/w;         % lateral scaling
          
            % plot front wheels
            xf=obj.frontaxlepos/sx;
            x=[xf - R, xf + R, xf + R, xf - R, xf - R];
            y=[0,    0,    40,   40,   0];
            fill(x,y,'k','EdgeColor','none','Parent',obj.hgtfrontwheels(1));
            fill(x,w-y,'k','EdgeColor','none','Parent',obj.hgtfrontwheels(2));
            
            wheelpos = [xf, 20; xf, w-20];

            % plot rear wheels
            xf=obj.rearaxlepos/sx;
            x=[xf - R, xf + R, xf + R, xf - R, xf - R];
            fill(x,y,'k','EdgeColor','none','Parent',obj.hgt);
            fill(x,w-y,'k','EdgeColor','none','Parent',obj.hgt);
            
            y=[45,  45,  85,  85,  45];
            fill(x,y,'k','EdgeColor','none','Parent',obj.hgt);
            fill(x,w-y,'k','EdgeColor','none','Parent',obj.hgt);
            
            % plot outer contour of chassis
            x=[0,   0,  15, 1577, 1601, 1620, 1628, 1630];
            y=[w/2, 17, 0,  0,    10,   38,   94,   w/2];
            fill([x,fliplr(x(1:end-1))], ...
                [y, w-fliplr(y(1:end-1))], ...
                obj.color,'EdgeColor','none','Parent',obj.hgt,'FaceAlpha',obj.facealpha);

            obj.scale(obj.hgt,0,0,sx,sy);
            obj.wheelradius = R*sx;
            obj.frontwheelspos(:,1) = wheelpos(:,1)*sx - obj.rearaxlepos;
            obj.frontwheelspos(:,2) = wheelpos(:,2)*sy - obj.width/2;
            
            % plot center of rear axle as a plus sign
            plot([-0.1 0.1]*obj.width,[0 0],'w','LineWidth',1.5,'Parent',obj.hgt);
            plot([0 0],[-0.1 0.1]*obj.width,'w','LineWidth',1.5,'Parent',obj.hgt);
        end
        
        %% turn the front wheels
        for j=1:numel(obj.hgtfrontwheels)
            frontwheelangle = obj.x(4);
            obj.hgtfrontwheels(j).Matrix=makehgtform('translate',obj.frontwheelspos(j,1),obj.frontwheelspos(j,2),0) ... 
                * makehgtform('zrotate',frontwheelangle) ...
                * makehgtform('translate',-obj.frontwheelspos(j,1),-obj.frontwheelspos(j,2),0);
        end

        % translate/rotate the vehicle
        obj.hgt.Matrix=makehgtform('translate',obj.x(1),obj.x(2),0)*makehgtform('zrotate',obj.x(3));
    end
   
end

methods (Hidden, Access=protected)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function scale(obj,hgt,minx,miny,sx,sy)
        % scale all shapes and center around the CoG
        for j=1:numel(hgt.Children)
            if ishghandle(hgt.Children(j),'hgtransform')
                obj.scale(hgt.Children(j),minx,miny,sx,sy)
            else
                hgt.Children(j).Vertices(:,1)=(hgt.Children(j).Vertices(:,1)-minx)*sx - obj.rearaxlepos;
                hgt.Children(j).Vertices(:,2)=(hgt.Children(j).Vertices(:,2)-miny)*sy - obj.width/2;
            end
        end
    end
end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Created by Nikolce Murgovski, 2019-03.