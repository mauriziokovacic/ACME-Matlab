function [Q] = compute_quaternion(T,W)
T = mat2quat(T);
Q = W * T;
Q = quatnormalize(Q);
end