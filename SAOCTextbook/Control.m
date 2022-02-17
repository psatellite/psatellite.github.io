function tC = Control( theta, d )

%% Control algorithm.
% This is a discrete proportional derivative controller.
%-------------------------------------------------------------------------------
%   Form:
%   tC = Control( theta, d )
%-------------------------------------------------------------------------------
%
%   ------
%   Inputs
%   ------
%   t               (3,1)  Angle (rad)
%   d                (.)   Data structure
%                          .inr (3,3) Inertia matrix (kg-m^2)
%                          .kF  (1,1) Forward gain
%                          .tau (1,1) Rate time constant
%                          .dT  (1,1) Time step
%
%   -------
%   Outputs
%   -------
%   tC              (3,1)  Control torque
%
%-------------------------------------------------------------------------------

%-------------------------------------------------------------------------------
%   Copyright (c) 2008, 2021 Princeton Satellite Systems, Inc.
%   All rights reserved.
%-------------------------------------------------------------------------------

persistent thetaOld;

if( isempty(thetaOld) )
    thetaOld = [0;0;0];
end

tC = -d.inr*d.kF*(theta + d.tau*(theta - thetaOld)/d.dT);

thetaOld = theta;


