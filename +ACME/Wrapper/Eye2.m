function [I] = Eye2(type)
if( nargin < 1 )
    type = 'linear';
end
I = eye(3);
if( strcmpi(type,'linear') )
    I = I(1:6);
end
end