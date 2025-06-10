function [H] = mean_curvature(P,T)
    Hn = mean_curvature_normal(P,T);
    H = 0.5 .* vecnorm3(Hn);
end