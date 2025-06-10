function [U] = align_field(U,V,Adj,iteration)
if( nargin < 4 )
    iteration = 3;
end
if( isempty(V) )
    V = U;
end
[I,J] = find(Adj);
for i = 1 : iteration
    W = dot(U(I,:),V(J,:),2);
    U = accumarray3(I,W.*V(J,:));
    S = accumarray(I,abs(W));
    U = normr(U./S);
end
end