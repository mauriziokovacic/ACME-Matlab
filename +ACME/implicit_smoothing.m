function [U] = implicit_smoothing(V,L,lambda,iteration)
if( nargin < 4 )
    iteration = 3;
end
if( nargin < 3 )
    lambda = 0.5;
end
U = V;
for i = 1 : iteration
    U = (speye(size(L)) + lambda*L ) \ U;
end
U = full(U);
end