function [I] = change_rigidity(P,T,W,type,iteration)
if( nargin < 5 )
    iteration = 5;
end
if( nargin < 4 )
    type = 'soften';
end
I = Phi(W);
if( strcmpi(type,'soften') )
    A = barycentric_area(P,T);
    L = cotangent_Laplacian(P,T);
    t = 0.25;
    M = decomposition(A+t*L);
    for i = 1 : iteration
        I = clamp((M\I),0,1);
    end
end

if( strcmpi(type,'harden') )
    for i = 1 : iteration
        I = I.*I;
    end
end
end