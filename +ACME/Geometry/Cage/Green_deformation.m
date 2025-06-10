function [P,N] = Green_deformation(T,Pc,Tc,Wc,Wt,St)
% Wc \in R^{PxC}, Pc \in {Cx3}, Wt \in R^{Pxtc}, St \in R^{tcxtc}
Nt = triangle_normal(Pc,Tc);
P = Wc * Pc + Wt * (St .* Nt);
N = face2vertex(triangle_normal(P,T),T);
end