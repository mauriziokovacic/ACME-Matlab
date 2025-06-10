function [E] = L21_Energy(B,N,A,Proxy)
D = N-cell2mat(Proxy(:,2));
E = A .* dot(D,D,2);
end