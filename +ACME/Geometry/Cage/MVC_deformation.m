function [P,N] = MVC_deformation(C,W,T)
%C \in R^{Cx3}, W \in R^{PxC), 
P = W*C;
N = vertex_normal(P,T);
% N = [];
end