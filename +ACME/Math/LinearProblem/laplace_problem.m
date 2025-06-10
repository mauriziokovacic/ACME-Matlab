function [u] = laplace_problem(L, d)
if(nargin < 2)
    d = 1;
end
u = poisson_problem(L, zeros(col(L), d));
end