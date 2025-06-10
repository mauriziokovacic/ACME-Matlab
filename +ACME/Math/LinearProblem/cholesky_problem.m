function [x] = cholesky_problem(Luk,L,Lt,vk,P)
b = -Luk * vk;
y = linear_problem(L,b);
x = linear_problem(Lt,y);
x = P' * [x; vk];
end