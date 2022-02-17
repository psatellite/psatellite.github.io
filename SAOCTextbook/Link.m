function p = Link( theta, r, t, d )

%% Computes the power on the ground from the spacecraft.
% Time is only used for plotting from within this routine.
%-------------------------------------------------------------------------------
%   Form:
%   p = Link( theta, r, t, d )
%-------------------------------------------------------------------------------
%
%   ------
%   Inputs
%   ------
%   theta           (3,:)  Pointing errors (rad)
%   r               (3,:)  ECI position vector (km)
%   t               (1,:)  Time (sec)
%   d               (1,1)  Link data structure
%                          .lambda (1,1) Wavelength (m)
%                          .latGS  (1,1) Latitude of beam center (deg)
%                          .lonGS  (1,1) Longitude of beam center (deg)
%                          .pRF    (1,1) Antenna power (deg);
%                          .aT     (1,1) Transmit antenna area
%                          .aR     (1,1) Receive antenna area
%
%   -------
%   Outputs
%   -------
%   p               (1,:)  Power on the ground (W)
%
%-------------------------------------------------------------------------------

%-------------------------------------------------------------------------------
%   Copyright (c) 2008, 2021 Princeton Satellite Systems, Inc.
%   All rights reserved.
%-------------------------------------------------------------------------------

% Demo
%-----
if( nargin == 0 )
    n        = 50;
    theta    = [linspace(-1,1,n);zeros(2,n)]*pi/180;
    angle    = linspace(0,2*pi,n);
    r        = 42167*[cos(angle);sin(angle);zeros(1,n)];
    t        = linspace(0,86400,n);
    d.lambda = 0.025; % Ku band
    d.latGS  = 40;
    d.lonGS  =  0;
    d.pRF    = 1000;
    d.aR     = pi*0.25^2;
    d.aT     = pi*0.5^2;
    Link( theta, r, t, d )
    return;
end

% Find the ground station location
%---------------------------------
degToRad = pi/180;
lat      = d.latGS*degToRad;
lon      = d.lonGS*degToRad;
rGS      = 6378.165*[cos(lon)*cos(lat);sin(lon)*cos(lat);sin(lat)];

% Earth rate
%-----------hmm
wo       = 2*pi/86400;

n        = length(t);
p        = zeros(1,n);

dT       = 2*sqrt(d.aT/pi);
gT       = 4*pi*d.aT/d.lambda^2;
gR       = 4*pi*d.aR/d.lambda^2;
theta3DB = 70*degToRad*d.lambda/dT;

% Gains
%------

for k = 1:n
    thetaE   = wo*t(k);
    c        = cos(thetaE);
    s        = sin(thetaE);
    rGST     = [c -s 0;s c 0;0 0 1]*rGS;
    RSq      = rGST'*r(:,k)*1e6; % Convert to m
    thetaErr = sqrt(theta(1,k)^2 + theta(2,k)^2);
    lR       = (4*pi/d.lambda)^2*RSq;
    lP       = 10^(1.2*(thetaErr/theta3DB)^2);
    p(k)     = d.pRF*gT*gR/(lR*lP); 
end

% Default output
%---------------
if( nargout == 0 )
    figure('name','Link');
    plot(t,10*log10(p))
    xlabel('Time (sec)')
    ylabel('Power (dBW)')
    title('Power on ground')
    grid
    clear p
end

