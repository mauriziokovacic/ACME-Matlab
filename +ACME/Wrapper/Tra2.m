function [T] = Tra2(t,type)
T = [eye(3,2),[t,1]'];
if( nargin < 2 )
    type = 'linear';
end
if( strcmpi(type,'linear') )
    T = linearize_transformation_matrix(T);
end
end