function [I] = fold_influence(P,T,S)
A  = barycentric_area(P,T);
t  = diffusion_time(1,mean_edge_length(P,T));
L  = cotangent_Laplacian(P,T);
K  = fold_boundary_condition(P,T,S);
U  = linear_problem(A+t*L,K);
gU = compute_gradient(P,T,U);
dU = compute_divergence(P,T,gU);
I  = normalize(linear_problem(L,dU));
end