function [P,N,C] = Center_Of_Rotation(P,N,W,Pose,C)
T  = compute_transform(Pose,W);
Q  = compute_quaternion(Pose,W);
PC = P-C;
C  = transform_point(T,C,'mat');
P  = C + transform_normal(Q,PC,'dq');
N  = transform_normal(Q,N,'dq');
N  = normr(N);
end