function [N] = adjacent_edge(T,E)
N = zeros(size(T,1),1);
[I,J,K] = tri2ind(T);

E  = sort(E,2);
Ei = sort([I,J],2);
Ej = sort([J,K],2);
Ek = sort([K,I],2);

N(prod(E==Ei)>0)=1;
N(prod(E==Ej)>0)=1;
N(prod(E==Ek)>0)=1;

end