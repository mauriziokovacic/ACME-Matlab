function [M] = dq2mat(DQ)
r = quaternion(realdq(DQ));
d = quaternion(dualdq(DQ));
R = quat2rotm(r);
T = compact(2 * r * conj(d));
M = [R T(1:end-1)';0 0 0 1];
end