function [R] = RotX(theta,type)
if( nargin < 2 )
    type = 'linear';
end
R = RUt([1 0 0],theta,type);
end