%% Spacecraft simulation script.
%
% Simulates the attitude, orbit, thermal, power and communications subsystems.
% Choose either solstice or equinox. This script makes use of the following
% MATLAB functions included with the tutorial:
%
% * Link.m
% * ThermalOptical.m
% * RHS.m
% * Control.m
% * PlotSimulationOutputs.m
%   
%-------------------------------------------------------------------------------

%-------------------------------------------------------------------------------
%   Copyright (c) 2008, 2021 Princeton Satellite Systems, Inc.
%   All rights reserved.
%-------------------------------------------------------------------------------

% Clean up previous runs
%-----------------------
close all
clear all

% Simulation setup
%-----------------
dT       = 8;    % Time step (s)
nDays    = 0.04; % 1 hour is about 0.04 days
nSim     = nDays*86400/dT;
xPlot    = zeros(26,nSim); % Initialize the plotting array

% Sun angle with respect to the orbit plane
%------------------------------------------
simName  = 'Equinox'; % For the plot titles

if( strcmpi(simName,'solstice' ))
    beta = 23.44*pi/180; % Summer solstice
elseif ( strcmpi(simName,'equinox' ))
    beta = 0;
else
    error( '%s not known',simName )
end

% The data structure d is used to pass parameters to all of the functions
%------------------------------------------------------------------------
d.d = 149597870*[cos(beta);0;sin(beta)]; % Sun vector in ECI frame

% Parameters
%-----------
d.inr    = diag([100;50;100]); % Inertia (kg-m^2)
d.inrInv = inv(d.inr); % Inverse inertia
d.mu2    = 3.98600436e5; % earth (km^3/s^2)
d.mu3    = 132712440018; % sun   (km^3/s^2)
d.eMax   = 500000; % Maximum battery charge (J)
d.m      = 1000; % Mass (kg)

% Thermal, power and disturbance
%-------------------------------
gamma    = 1*pi/180; % Inward tilt angle of the arrays (rad)
d.rhoA   = 1; % Surface absorptivity
d.eps    = 1; % Surface emissivity
d.eta    = 0.215; % Solar cell conversion efficiency
rN       = [0;-5;0]; % Vector to the north array center-of-pressure (m)
rS       = [0; 5;0]; % Vector to the sorth array center-of-pressure (m)
d.a      = 2; % Solar array area (m^2)

% Control
%--------
d.dT     = dT;
d.kF     = 0.00001;
d.tau    = 2/sqrt(d.kF);

% Link
%-----
d.pRF    = 1000;  % RF transmitter power (W)
d.lambda = 0.025; % (m) Ku band
d.latGS  = 20;    % Latitude of beam center (deg)
d.lonGS  =  0;    % Longitude of beam center (deg)
d.aT     = pi*0.50^2; % Transmit antenna area
d.aR     = pi*0.25^2; % Receive antenna area

% State: [position;velocity;angle;angular rate;battery charge]
%-------------------------------------------------------------
r        = [42167;0;0]; % Position (km)
v        = [0;sqrt(d.mu2/r(1));0]; % Velocity (km/s)
d.wo     = sqrt(d.mu2/r(1)^3); % Magnitude of the initial orbit rate
q        = [0.0;0.0;0.1];      % Small angles from local vertical (rad)
w        = [0;-d.wo;0];        % Inertial angular rate (rad/s)
e        = 0; % Battery charge (J)
x        = [r;v;q;w;e];

% Initial time
%-------------
t = 0; % Start time (s)

% Run the sim
%------------
for k = 1:nSim
    % Control
    %--------
    d.tC         = Control( x(7:9), d );
    
    % Thermal, power and disturbance model
    %-------------------------------------
    d.gamma      = gamma;
    [tN, fN, pN] = ThermalOptical( beta, d );
    d.gamma      = -gamma;
    [tS, fS, pS] = ThermalOptical( beta, d );
    f            = fN + fS; % force (N)
    d.tD         = cross(rN,fN) + cross(rS,fS);
    d.p          = pS + pN; % power (W)
    d.f          = fS + fN; % force (N)

    % Link model
    %-----------
    pT = 10*log10(Link( x(7:8), x(1:3), t, d ));
    
    % Plot vector
    %------------
    xPlot(:,k) = [x;f;d.p;tN;tS;d.tD;d.tC;pT]; 
    
    % Integrate one step
    %-------------------
    [t, x]       = ode45(@RHS,[t t+dT], x, [], d );
    t            = t(end);
    x            = x(end,:)';
end

%% Plot the results
%------------------
PlotSimulationOutputs( (0:(nSim-1))*dT, xPlot, simName, sqrt(d.mu2/r(1)^3) );
