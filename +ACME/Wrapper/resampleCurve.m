function [Q] = resampleCurve(P,n,method,varargin)
if(nargin < 3)
    method = 'pchip';
end
if(nargin < 2)
    n = 20;
end
if(row(P)==1)
    Q = P;
    return;
end
n  = min(max(row(P),n),n);
x  = curve2param(P);
xq = linspace(0,1,n)';
Q  = interp1(x,P,xq,method,varargin{:});
end