function [R] = Rot3(theta,dim,type)
if( nargin < 3 )
    type = 'linear';
end
if( nargin < 2 )
    dim = 1;
end
if( nargin < 1 )
    theta = pi/2;
end
switch dim
    case 2
        R = RotY(theta,type);
    case 3
        R = RotZ(theta,type);
    otherwise
        R = RotX(theta,type);
end
end