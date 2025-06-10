function [N] = triangle_normal(P,varargin)
if( nargin == 2 )
    T = varargin{1};
    [I,J,K] = tri2ind(T);
    Eij = P(J,:)-P(I,:);
    Eik = P(K,:)-P(I,:);
    N = normr(cross(Eij, Eik, 2));
    return;
end
if( nargin == 3 )
    Nv = varargin{1};
    T  = varargin{2};
    [I,J,K] = tri2ind(T);
    N = normr(Nv(I,:)+Nv(J,:)+Nv(K,:));
end
end