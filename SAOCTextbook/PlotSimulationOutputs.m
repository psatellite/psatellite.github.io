function PlotSimulationOutputs( t, x, name, wo )

%-------------------------------------------------------------------------------
%   Plots the simulation outputs.
%-------------------------------------------------------------------------------
%   Form:
%   PlotSimulationOutputs( t, x )
%-------------------------------------------------------------------------------
%
%   ------
%   Inputs
%   ------
%   t               (1,:)  Time (sec)
%   x               (3,:)  [r;v;theta;omega;eB;f;p;tN;tS;tD;tC;pT]
%   name            (1,:)  Name for the simulation
%   wo              (1,1)  Rotation rate
%
%   -------
%   Outputs
%   -------
%   None
%
%-------------------------------------------------------------------------------

%-------------------------------------------------------------------------------
%   Copyright (c) 2008 Princeton Satellite Systems, Inc.
%   All rights reserved.
%-------------------------------------------------------------------------------

% Break up the plot vector
%-------------------------
r  = x( 1: 3,:);
v  = x( 4: 6,:);
q  = x( 7: 9,:);
w  = x(10:12,:);
e  = x(13:13,:);
f  = x(14:16,:);
p  = x(17:17,:);
T  = x(18:19,:);
tD = x(20:22,:);
tC = x(23:25,:);
pT = x(26:26,:);

% Convert time to hours
%----------------------
tS = t;
t = t/3600;
tL = 'Time (hr)';

% Orbit
%------
h = figure;
set(h,'name','Orbit','numbertitle','off','color',[1 1 1]);

subplot(3,1,1)
plot(t,r);
ylabel('Position (km)');
legend({'x' 'y' 'z'});
grid
title([name ' Orbit'])

subplot(3,1,2)
plot(t,v);
ylabel('Velocity (km/s)');
legend({'x' 'y' 'z'});
grid

subplot(3,1,3)
plot(t,f*1e6);
ylabel('Force (\mu N)');
legend({'x' 'y' 'z'});
grid
xlabel(tL)

% Attitude
%---------
h = figure;
set(h,'name','Attitude','numbertitle','off','color',[1 1 1]);

subplot(3,1,1)
plot(t,q*180/pi);
ylabel('\theta (deg)');
legend({'x' 'y' 'z'});
grid
title([name ' Attitude'])

subplot(3,1,2)
plot(t,w);
ylabel('\omega (rad/s)');
legend({'x' 'y' 'z'});
grid

subplot(3,1,3)
plot(t,[tC;tD]*1e6);
ylabel('Torque (\mu Nm)');
legend({'xC' 'yC' 'zC' 'xD' 'yD' 'zD'});
grid
xlabel(tL)

% Thermal and power
%------------------
h = figure;
set(h,'name','Thermal and Power','numbertitle','off','color',[1 1 1]);

subplot(2,2,1)
plot(t,e);
ylabel('Battery (W-s)');
grid
title([name ' Thermal and Power'])

subplot(2,2,2)
plot(t,T);
ylabel('Panel Temperature (deg-K)');
legend({'N' 'S'});
grid

subplot(2,2,3)
plot(t,p);
ylabel('Power (W)');
grid
xlabel(tL)

subplot(2,2,4)
plot(t,pT);
ylabel('RF power (dBW)');
grid
xlabel(tL)

h = figure;
set(h,'name','Relative Orbit','numbertitle','off','color',[1 1 1]);

c  = cos(wo*tS);
s  = sin(wo*tS);

% Transform into a rotating reference frame
%------------------------------------------
rT = r;
for k = 1:length(t)
    rT(:,k) = [c(k) s(k) 0;-s(k) c(k) 0;0 0 1]*r(:,k) - [42167;0;0];
end


subplot(2,2,1)
plot(rT(1,:),rT(2,:));
xlabel('\Delta x (km)')
ylabel('\Delta y (km)');
title('Rotating frame')
grid

subplot(2,2,2)
plot(t,rT(3,:));
xlabel(tL)
ylabel('\Delta z (km)');
title('Rotating frame')

grid


subplot(2,2,3)
plot(t,r);
xlabel(tL)
ylabel('Position (km)');
grid
title('ECI frame')


subplot(2,2,4)
plot(t,rT(1:2,:));
xlabel(tL)
ylabel('Position (km)');
title('Rotating frame')
grid
legend({'\Delta x' '\Delta y'},'location','northwest')


%--------------------------------------
% PSS internal file version information
%--------------------------------------
% $Date: 2013-12-30 16:59:03 -0500 (Mon, 30 Dec 2013) $
% $Revision: 36558 $

