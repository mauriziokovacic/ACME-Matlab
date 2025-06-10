function [E] = Lloyd_Energy(B,N,A,Proxy)
E = vecnorm3(B-cell2mat(Proxy(:,1)));
end