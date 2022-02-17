function PlotSimulationOutputs( t, x, name, wo )

%% Plots the simulation outputs.
%-------------------------------------------------------------------------------
%   Form:
%   PlotSimulationOutputs( t, x )
%-------------------------------------------------------------------------------
%
%   ------
%   Inputs
%   ------
%   t               (1,:)  Time (sec)
%   x              (26,:)  [r;v;theta;omega;eB;f;p;tN;tS;tD;tC;pT]
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
%   Copyright (c) 2008, 2021 Princeton Satellite Systems, Inc.
%   All rights reserved.
%-------------------------------------------------------------------------------

% Break up the plot vector
%-------------------------
r  = x( 1: 3,:);  % position
v  = x( 4: 6,:);  % velocity
q  = x( 7: 9,:);  % body angles
w  = x(10:12,:);  % body rates
e  = x(13:13,:);  % battery energy
f  = x(14:16,:);  % solar forces
p  = x(17:17,:);  % power
T  = x(18:19,:);  % array temperatures
tD = x(20:22,:);  % disturbance torque
tC = x(23:25,:);  % control torque
pT = x(26:26,:);  % link power

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
grid on
title([name ' Attitude'])

subplot(3,1,2)
plot(t,w);
ylabel('\omega (rad/s)');
legend({'x' 'y' 'z'});
grid on

subplot(3,1,3)
lh = plot(t,[tC;tD]*1e6);
ylabel('Torque (\mu Nm)');
xlabel(tL)
grid on
set(lh(4:6),'linestyle','--')
legend({'xC' 'yC' 'zC' 'xD' 'yD' 'zD'});

% Thermal and power
%------------------
h = figure;
set(h,'name','Thermal and Power','numbertitle','off','color',[1 1 1]);

subplot(2,2,1)
plot(t,e);
ylabel('Battery (W-s)');
grid on
title([name ' Thermal and Power'])

subplot(2,2,2)
plot(t,T);
ylabel('Panel Temperature (deg-K)');
legend({'N' 'S'});
grid on

subplot(2,2,3)
plot(t,p);
ylabel('Power (W)');
grid on
xlabel(tL)

subplot(2,2,4)
plot(t,pT);
ylabel('RF power (dBW)');
grid on
xlabel(tL)


% Transform into a rotating reference frame
%------------------------------------------
c  = cos(wo*tS);
s  = sin(wo*tS);
rT = r;
for k = 1:length(t)
    rT(:,k) = [c(k) s(k) 0;-s(k) c(k) 0;0 0 1]*r(:,k) - [42167;0;0];
end
h = figure;
set(h,'name','Relative Orbit','numbertitle','off','color',[1 1 1]);

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
grid on

subplot(2,2,3)
plot(t,r);
xlabel(tL)
ylabel('Position (km)');
grid on
title('ECI frame')

subplot(2,2,4)
plot(t,rT(1:2,:));
xlabel(tL)
ylabel('Position (km)');
title('Rotating frame')
grid on
legend({'\Delta x' '\Delta y'})



