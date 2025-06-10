function [P,N] = Maya_Skinning(P,N,W,Pose,alpha)
if( nargin < 5 )
    alpha = 0.5;
end
T  = compute_transform(Pose,W);
DQ = compute_dualquaternion(Pose,W);
P  = (1-alpha) * transform_point(T,P,'mat') + alpha * transform_point(DQ,P,'dq');
N  = (1-alpha) * transform_normal(T,N,'mat') + alpha * transform_normal(DQ,N,'dq');
N  = normr(N);
end