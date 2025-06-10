function [P,N,UV,T,W] = PlaneRigged(Side,Res)
[P,N,T,UV] = Plane(Side,Res);
W = normalize(P(:,1),-Side/2,Side/2);
W = [W 1-W];
W = W./sum(W,2);
end