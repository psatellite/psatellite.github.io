%-------------------------------------------------------------------------------
%   Simulation of a spacecraft in GEO orbit. 
%   Includes gravitational acceleration from the sun and Earth.
%
%   Simulates the orbit and shows the apparent motion of the spacecraft in
%   a coordinate frame that rotates with the Earth.
%-------------------------------------------------------------------------------

%-------------------------------------------------------------------------------
%   Copyright (c) 2008 Princeton Satellite Systems, Inc.
%   All rights reserved.
%-------------------------------------------------------------------------------

% Clean up previous runs
%-----------------------
close all
clear all

% Time for the maneuver
%----------------------

% Simulation setup
%-----------------
dT       = 8; % Time step (s)
nDays    = 2;
nSim     = nDays*86400/dT; % Number of simulation steps
xPlot    = zeros(6,nSim); % Initialize the plotting array
name     = 'Stationkeeping';

% Sun angle with respect to the orbit plane
%------------------------------------------
beta     = 23.44*pi/180; % Summer solstice
d.d      = 149597870*[cos(beta);0;sin(beta)]; % Sun vector in ECI frame

% Parameters
%-----------
d.mu2    = 3.98600436e5; % earth (km^3/s^2)
d.mu3    = 132712440018; % sun (km^3/s^2)
d.phiS   = 75*pi/180; % Location of orbit equilibrium point (rad)

% State: [position;velocity
%--------------------------
r        = [42167;0;0]; % Position (km)
v        = [0;sqrt(d.mu2/r(1));0]; % Velocity (km/s)
wo       = sqrt(d.mu2/r(1)^3);
x        = [r;v];

% Initial time
%-------------
t        = 0; % Start time (s)

xODEOptions = odeset( 'AbsTol', 1e-9, 'RelTol', 1e-6 );


% Run the sim
%------------
for k = 1:nSim
    
    % Plot vector
    %------------
    xPlot(:,k)   = x; 
    
    % Integrate one time step
    %------------------------
    [t, x]       = ode45(@RHSOrbit,[t t+dT], x, xODEOptions, d );
    
    t            = t(end);
    x            = x(end,:)';
end

% Plot the results
%-----------------
r  = xPlot( 1: 3,:);
v  = xPlot( 4: 6,:);

% Orbit
%------
h = figure;
set(h,'name','Orbit','numbertitle','off');


t  = (0:(nSim-1))*dT;
c  = cos(wo*t);
s  = sin(wo*t);

% Transform into a rotating reference frame
%------------------------------------------
rT = r;
for k = 1:length(t)
    rT(:,k) = [c(k) s(k) 0;-s(k) c(k) 0;0 0 1]*r(:,k) - [42167;0;0];
end


% Convert time to hours
%----------------------
t = t/3600;
tL = 'Time (hr)';


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
