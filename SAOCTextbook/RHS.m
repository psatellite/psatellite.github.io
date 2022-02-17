function xDot = RHS( ~, x, d )

%% Right hand side of the integrated simulation.
% Includes orbit dynamics, attitude dynamics, and a charging model.
%-------------------------------------------------------------------------------
%   Form:
%   xDot = RHS( t, x, d )
%-------------------------------------------------------------------------------
%
%   ------
%   Inputs
%   ------
%   t               (1,:)  Time (sec) (unused)
%   x               (3,:)  [r;v;theta;omega;eB]
%   d                (.)  Data structure
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

% Break the state down
%---------------------
r    = x( 1: 3,:);  % position
v    = x( 4: 6,:);  % velocity
q    = x( 7: 9,:);  % body angles
w    = x(10:12,:);  % body rates
e    = x(13:13,:);  % battery energy

lon  = atan2(r(2),r(1));
rMag = Mag(r);

% Longitudinal acceleration, J2 term
%-----------------------------------
a    = 6378.137;
s22  = -9.0359e-07;
c22  = 1.5743e-06;
aT   = d.mu2*(6*a^2/rMag^4)*(s22*cos(2*lon) - c22*sin(2*lon));

u    = [r(2);-r(1);0];
u    = u/Mag(u);
rMD  = r - d.d;
aSun = -d.mu3*(rMD/Mag(rMD)^3 + d.d/Mag(d.d)^3);
aE   = -d.mu2*r/rMag^3; % Earth

aS   = d.f/d.m; % solar panel perturbing force
aS   = [0;0;0];

vDot = aE + aSun + aS + aT*u;
qDot = w + d.wo*[q(3);1;-q(1)];
wDot = d.inrInv*(d.tD + d.tC - cross( w, d.inr*w ));

% Battery model
%--------------
if( e >= d.eMax )
  eDot = 0;
else
  eDot = d.p - d.pRF;
end

xDot = [v;vDot;qDot;wDot;eDot];

%-------------------------------------------------------------------------------
%   Vector magnitude function
%-------------------------------------------------------------------------------
function m = Mag( x )

m = sqrt( x'*x );

