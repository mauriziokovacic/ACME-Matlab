function [F] = weight2fold(W,N)
if( nargin < 2 )
    N = 1;
end
F = zeros(row(W),1);
for n = 1 : N
    w = weight2superbone(W,n);
    for i = 1 : col(w)
        F = max(F,phi_i(w(:,i)));
    end
end
end