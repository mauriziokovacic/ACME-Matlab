function [h] = create_torus(Radius,Width,varargin)
% we convert our vectors phi and th to [n x n] matrices with meshgrid command:
[Phi,Theta] = meshgrid(linspace(0,2*pi,33),linspace(0,2*pi,33)); 
% now we generate n x n matrices for x,y,z according to eqn of torus
x = (Radius + Width * cos(Theta)) .* cos(Phi);
y = (Radius + Width * cos(Theta)) .* sin(Phi);
z = Width * sin(Theta);
h = surf(x,y,z,varargin{:}); % plot surface
end