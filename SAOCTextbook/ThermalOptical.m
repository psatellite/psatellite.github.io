function [t, f, p] = ThermalOptical( beta, d )

%% Temperature, force and power due to solar flux.
%-------------------------------------------------------------------------------
%   Form:
%   [t, f, p] = ThermalOptical( beta, d )
%-------------------------------------------------------------------------------
%
%   ------
%   Inputs
%   ------
%   beta            (1,:)  Sun angle rad
%   d                (.)   Temperature data structure
%                          .a      (1,1) Area (m^2)
%                          .gamma  (1,1) Tilt angle (rad)
%                          .rhoA   (1,1) Absorption coeffiicent (0-1)
%                          .eps    (1,1) Emissivity (0-1)
%                          .eta    (1,1) Cell conversion efficiency (0-1)
%
%   -------
%   Outputs
%   -------
%   t               (1,:)  Temperature (deg-K)
%   f               (1,:)  Force (N)
%   p               (1,:)  Power (W)
%
%-------------------------------------------------------------------------------

%-------------------------------------------------------------------------------
%   Copyright (c) 2008, 2021 Princeton Satellite Systems, Inc.
%   All rights reserved.
%-------------------------------------------------------------------------------

% Demo
%-----
if( nargin == 0 )
    d.eta    = 0.21;
    d.gamma  = 0;
    d.eps    = 1;
    d.rhoA   = 1.0;
    d.a      = 2;
    beta     = linspace(-23,23)*pi/180;
    ThermalOptical( beta, d )
    return;
end

% Constants
%----------
sigma = 5.67e-8; % Boltzmann's Constant
S     = 1367; % Solar flux (W/m^2)
c     = 3e8; % Speed of light (m/s)

% Find the incoming flux factor
%------------------------------
delta = cos(beta)*cos(d.gamma) + sin(beta)*sin(d.gamma);

% Temperature
%------------
t     = (0.5*(1-d.eta)*d.rhoA*S*delta/(sigma*d.eps)).^0.25;

% Power
%------
p     = d.eta*d.rhoA*d.a*S*delta;

% Force
%-------
rhoS  = 1 - d.rhoA;
n     = [sin(d.gamma);cos(d.gamma);0];
s     = [zeros(1,length(beta));sin(beta);cos(beta)];
f0    = -S*d.a*delta/c;
f1    = 2*rhoS*delta;
f     = [f0;f0;f0].*([f1*n(1);f1*n(2);f1*n(3)] + d.rhoA*s);

% Default output
%---------------
if( nargout == 0 )
    figure('name','ThermalOptical');
    beta = beta*180/pi;
    
    subplot(1,3,1)
    plot(beta,t)
    xlabel('\beta (deg)')
    ylabel('Temperature (deg-K)')
    title('Panel Temperature')
    grid on
    
    subplot(1,3,2)
    plot(beta,p)
    xlabel('\beta (deg)')
    ylabel('Power (W)')
    title('Panel Power')
    grid on
    
    subplot(1,3,3)
    h = plot(beta,f*1e6);
    set(h(1),'LineStyle','-');
    set(h(2),'LineStyle','--');
    set(h(3),'LineStyle','-.');
    xlabel('\beta (deg)')
    ylabel('Force (\mu N)')
    title('Panel Force')
    grid on
    legend({'x' 'y' 'z'})

    clear t
end

