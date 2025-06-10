function [R] = RotZ(theta,type)
if( nargin < 2 )
    type = 'linear';
end
R = RUt([0 0 1],theta,type);
end