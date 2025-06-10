function [G] = genus(Point,Edge,Face,Volume)
if(nargin<4)
    Volume = [];
end
G = Euler_characteristic(Point,Edge,Face,Volume) - 2;
end