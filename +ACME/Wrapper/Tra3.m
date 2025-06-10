function [T] = Tra3(t,type)
if( nargin < 2 )
    type = 'linear';
end
T = [eye(4,3),[t,1]'];
if( strcmpi(type,'linear') )
    T = mat2lin(T);
end
end