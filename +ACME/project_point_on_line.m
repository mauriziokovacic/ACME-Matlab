function [Q,varargout] = project_point_on_line(A,B,P,type)
if( nargin < 4 )
    type = 'line';
end
if( size(P,1) == 1 )
    P = repmat(P,size(A,1),1);
end
if( size(A,1) == 1 )
    A = repmat(A,size(P,1),1);
    B = repmat(B,size(P,1),1);
end
E  = B-A;
L2 = dot(E,E,2);
t  = dot(P-A,E,2)./L2;
t(~isfinite(t)) = 0;
if( strcmpi(type,'ray') )
    t = clamp(t,0,max(t));
end
if( strcmpi(type,'segment') )
    t = clamp(t,0,1);
end
Q = A + t .* E;
if( nargout >= 2 )
    varargout{1} = t;
end
end