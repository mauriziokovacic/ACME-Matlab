function [R] = RUt(U,theta,type)
R = [axang2rotm([U,theta]),[0;0;0];[0 0 0 1]];
if( nargin < 3 )
    type = 'linear';
end
if( strcmpi(type,'linear') )
    R = mat2lin(R);
end
end