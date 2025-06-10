function [P, N, UV, T, Q] = create_plane( res, side )
x = @(v,n) v(1:n);
q = @(i,n) x(i + reshape((0:(n-1))'+(0:(n+1):n*(n)),n*n,1),n*n);
if( ( nargin < 2 ) || ( side <= 0 ) ) side = 1; end
if( nargin == 0 ) res = 4; end
if( res <= 0 ) res = 1; end
res = res+1;
P = [reshape(repmat(linspace(-side/2,side/2,res) ,res,1),res^2,1),...
     reshape(repmat(linspace(-side/2,side/2,res)',res,1),res^2,1),...
     zeros(res^2,1)];
N = repmat([0,0,1],res*res,1);
UV = [reshape(repmat(linspace(0,1,res) ,res,1),res^2,1),...
      reshape(repmat(linspace(0,1,res)',res,1),res^2,1)];
res = res-1;
Q = [q(1,res),q(res+2,res),q(res+3,res),q(2,res)];
T = [Q(1:end,1) Q(1:end,2) Q(1:end,3); Q(1:end,3) Q(1:end,4) Q(1:end,1)];
end