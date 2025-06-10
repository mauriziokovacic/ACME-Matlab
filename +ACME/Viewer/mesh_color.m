function [C] = mesh_color(P,T,C)
L = combinatorial_Laplacian(P,T);
F = normalize(clamp(gaussian_curvature(P,T),-0.1,0.1));
F = (speye(row(P),row(P))+0.2*L)\F;
t = 0.5;
C = (1-t) .* repmat(C,row(P),1) + t .* fetch_color(color_palette('dusk'),F);%[F F F];
C = (speye(row(P),row(P))+0.2*L)\C;
end