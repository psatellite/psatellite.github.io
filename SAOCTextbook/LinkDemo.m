%% Demonstrate the Link function

n     = 50;
theta = [linspace(-1,1,n);zeros(2,n)]*pi/180;
angle = linspace(0,2*pi,n);
r     = 42167*[cos(angle);sin(angle);zeros(1,n)];
t     = linspace(0,86400,n); % time (s)

d.lambda = 0.025; % Ku band
d.latGS  = 40;
d.lonGS  =  0;
d.pRF    = 1000;
d.aR     = pi*0.25^2;
d.aT     = pi*0.5^2;

Link( theta, r, t, d )