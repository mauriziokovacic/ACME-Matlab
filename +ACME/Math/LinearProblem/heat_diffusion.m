function [h] = heat_diffusion(A,t,L,k)
    h = linear_problem(A+t*L,k);
    h = full(h);
end