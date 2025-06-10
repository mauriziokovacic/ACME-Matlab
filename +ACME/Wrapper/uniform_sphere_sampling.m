function [U] = uniform_sphere_sampling(n)
[u,v,w] = meshgrid(linspace(-1,1,n));
U = normr([u(:) v(:) w(:)]);
end