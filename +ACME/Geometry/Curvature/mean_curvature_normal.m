function [Hn] = mean_curvature_normal(P,T)
    A  = 1 ./ ( 2 .* diag(barycentric_area(P,T)) );
    Hn = A .* (cotangent_Laplacian(P,T) * P);
end