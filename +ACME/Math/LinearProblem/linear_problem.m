function [x] = linear_problem(A,b)
    x = (A+0.0001*speye(size(A)))\b;
end