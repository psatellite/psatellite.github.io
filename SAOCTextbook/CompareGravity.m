%% Compare simple and 36x36 gravity models
% Loads the previously computed accel.mat file that uses the 36x36 model.
%-------------------------------------------------------------------------------

%-------------------------------------------------------------------------------
%   Copyright (c) 2008 Princeton Satellite Systems, Inc.
%   All rights reserved.
%-------------------------------------------------------------------------------

r   = 42167;            % Orbit radius (km)
lon = linspace(0,2*pi); % Lognitude (rad)
mu  = 398600.436;       % Earth gravitational constant (km^3/s^2)
a   = 6378.137;         % Earth radius (km)
s22 = -9.0359e-07;      % J2 terms
c22 = 1.5743e-06;
x   = mu*(6*a^2/r^4)*(s22*cos(2*lon) - c22*sin(2*lon));

figure('name','Gravity comparison','color',[1 1 1])
load accel
h = plot(lon*180/pi, [x;accel] );
xlabel( 'Longitude (deg)')
ylabel( 'Acceleration (km/s^2)')
title ('Longitudinal acceleration')
legend({'Simplified model' '36x36 Spherical harmonic model'})
grid on
set(h(1),'LineStyle','-');
set(h(2),'LineStyle','--');

