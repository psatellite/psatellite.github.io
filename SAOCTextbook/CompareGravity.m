%-------------------------------------------------------------------------------
%   Compare gravity models
%-------------------------------------------------------------------------------

%-------------------------------------------------------------------------------
%   Copyright (c) 2008 Princeton Satellite Systems, Inc.
%   All rights reserved.
%-------------------------------------------------------------------------------

r   = 42167;
lon = linspace(0,2*pi);
mu  = 398600.436; % Earth graviational constant (km^3/s^2)
a   = 6378.137; % Earth radius (km)
s22 = -9.0359e-07;
c22 = 1.5743e-06;
x   = mu*(6*a^2/r^4)*(s22*cos(2*lon) - c22*sin(2*lon));

h   = figure;
set( h, 'name', 'Gravity comparison','color',[1 1 1])
load accel
h = plot(lon*180/pi, [x;accel] );
xlabel( 'Longitude (deg)')
ylabel( 'Acceleration (km/s^2)')
title ('Longitudinal acceleration')
legend({'Simplified model' '36x36 Spherical harmonic model'})
grid
set(h(1),'LineStyle','-');
set(h(2),'LineStyle','--');



%--------------------------------------
% PSS internal file version information
%--------------------------------------
% $Date: 2013-12-30 16:59:03 -0500 (Mon, 30 Dec 2013) $
% $Revision: 36558 $
