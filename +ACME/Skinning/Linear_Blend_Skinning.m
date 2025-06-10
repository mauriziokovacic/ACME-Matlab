function [P,N] = Linear_Blend_Skinning(P,N,W,Pose)
T = compute_transform(Pose,W);
P = transform_point(T,P,'mat');
N = transform_normal(T,N,'mat');
N = normr(N);
end