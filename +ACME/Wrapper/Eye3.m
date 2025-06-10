function [I] = Eye3(type)
if( nargin < 1 )
    type = 'linear';
end
I = eye(4);
if( strcmpi(type,'linear') )
    I = I(1:12);
end
end