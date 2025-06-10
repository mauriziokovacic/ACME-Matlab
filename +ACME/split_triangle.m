function [P,N,T] = split_triangle(P,N,T,ID)
if(nargin<4)
    ID = (1:row(T))';
end
n = row(P);
P = [P;triangle_barycenter(P,T(ID,:))];
N = [N;triangle_barycenter(N,T(ID,:))];
m = size(P,1);
t = [[T(ID,[1,2]);T(ID,[2,3]);T(ID,[3,1])], repmat(((n+1):m)',3,1)];
T(ID,:) = [];
T = [T;t];
end