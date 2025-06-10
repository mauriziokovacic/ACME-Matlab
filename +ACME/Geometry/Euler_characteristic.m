function [n] = Euler_characteristic(Point,Edge,Face,Volume)
if(nargin<4)
    Volume = [];
end
n = row(Point) - row(Edge) + row(Face) - row(Volume);
end