function [P,N] = Dual_Quaternion_Skinning(P,N,W,Pose)
DQ = compute_dualquaternion(Pose,W);
P  = transform_point(DQ,P,'dq');
N  = transform_normal(DQ,N,'dq');
N  = normr(N);
end