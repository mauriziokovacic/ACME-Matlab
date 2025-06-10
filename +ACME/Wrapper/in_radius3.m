function [J,D] = in_radius3(I,radius,dist)
if(nargin<3)
    dist = @(i,j) vecnorm(i-j,2,2);
end
[J,D] = in_radiusn(I,radius,dist);
end