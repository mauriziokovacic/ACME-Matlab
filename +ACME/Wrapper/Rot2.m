function [R] = Rot2(theta,type)
if( nargin < 2 )
    type = 'linear';
end
R = RotZ(theta,type);
if( strcmpi(type,'linear') )
    R = R(1:6);
else
    R = R(1:3,1:3);
end
end