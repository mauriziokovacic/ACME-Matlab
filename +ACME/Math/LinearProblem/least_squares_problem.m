function [x] = least_squares_problem(A,b)
    x = linear_problem(A'*A, A'*b);
end