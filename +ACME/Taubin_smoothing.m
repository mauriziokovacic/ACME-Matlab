function [P] = Taubin_smoothing(K, P, lambda, mu, n)
if(nargin<5)
    n = 1;
end
if(nargin<4)
    mu = -0.6;
end
if(nargin<3)
    lambda = 0.4;
end
%D = spdiags(sqrt(sum(A,2)), 0, row(A), row(A));
%K = D * A * D;
I = speye(row(K));
M = ((I-mu*K)*(I-lambda*K))^n;
P = M*P;
end