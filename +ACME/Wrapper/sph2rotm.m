function [M] = sph2rotm(S)
u = [1 0 0]';
M = axang2rotm([0 0 1 S(2)]);
u = M*u;
M = (eye(3)*S(1)) * axang2rotm([normr(cross([0 0 1],u',2)) S(3)])*M;
end