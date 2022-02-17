function xDot = RHSOrbit( t, x, d )

%% Right hand side of the orbit simulation.
%-------------------------------------------------------------------------------
%   Form:
%   xDot = RHSOrbit( t, x, d )
%-------------------------------------------------------------------------------
%
%   ------
%   Inputs
%   ------
%   t               (1,1)  Time (sec) - unused
%   x               (6,1)  [r;v]
%   d               (1,1)  Data structure
%
%   -------
%   Outputs
%   -------
%   xDot            (6,1)  [rDot;vDot]
%
%-------------------------------------------------------------------------------

%-------------------------------------------------------------------------------
%   Copyright (c) 2008 Princeton Satellite Systems, Inc.
%   All rights reserved.
%-------------------------------------------------------------------------------

% Break the state down
%---------------------
r    = x( 1: 3,:);
v    = x( 4: 6,:);

lon  = atan2(r(2),r(1));
rMag = Mag(r);

% Longitudinal acceleration
%--------------------------
a    = 6378.137;
s22  = -9.0359e-07;
c22  = 1.5743e-06;
aT   = d.mu2*(6*a^2/rMag^4)*(s22*cos(2*lon) - c22*sin(2*lon));

u    = [r(2);-r(1);0];
u    = u/Mag(u);
rMD  = r - d.d;
aSun = -d.mu3*(rMD/Mag(rMD)^3 + d.d/Mag(d.d)^3);
aE   = -d.mu2*r/rMag^3;

vDot = aE + aSun + aT*u;
xDot = [v;vDot];

%-------------------------------------------------------------------------------
%   Vector magnitude function
%-------------------------------------------------------------------------------
function m = Mag( x )

m = sqrt( x'*x );

