function [R] = RotY(theta,type)
if( nargin < 2 )
    type = 'linear';
end
R = RUt([0 1 0],theta,type);
end