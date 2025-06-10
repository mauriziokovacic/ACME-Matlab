function [theta] = positive_angle(A,B,N)
theta = signed_angle(A,B,N);
i = find(theta<0);
theta(i) = pi+theta(i);
end