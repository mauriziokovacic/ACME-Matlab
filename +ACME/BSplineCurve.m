% P_i control points with i = 0,...,n    
% t_i knots with i = 0,...,m
% k order
% m = n + k + 1
%
% N_{i,k}(u) basis
% N_{i,1}(u) = 1 if u in [t_i,t_{i+1}), 0 otherwise
% N_{i,k}(u) =     u - t_i                           t_{i+k} - u
%              --------------- * N_{i  ,k-1}(u) + ----------------- * N_{i+1,k-1}(u)
%              t_{i+k-1} - t_i                    t_{i+k} - t_{i+1}
%
% u ranges in [t_{k-1},t_{n+1})
% t = { t_0, .... , t_{k-1}, t_k, ... , t_n, t_{n+1}, ..., t_{n+k} }
%       |- k equal knots -|  n-k+1 internal  |-- k equal knots --|

function [Q,varargout] = BSplineCurve(ctrl,order,u)
if( nargin < 2 )
    order = 4;
end
n = size(ctrl,1)-1;
k = order;
if( n < k-1 )
    k = n;
end
[t,range] = BSplineKnots(ctrl,k);
if( nargin < 3 )
    u = linspace(range(1),range(2),101)';
    u = u(1:end-1);
else
    % remap u in range
    u = range(1) + u .* (range(2)-range(1));
end
Q = zeros(size(u,1),size(ctrl,2));
for i = 0 : n
    Bi = BSplineBasis(t,i,k,u);
    Ci = ctrl((i)+1,:);
    Q = Q + Bi .* Ci;
end
if( nargout > 1 )
    varargout{1} = t;
end
if( nargout > 2 )
    varargout{2} = range;
end
end