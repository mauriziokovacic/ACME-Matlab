function [k1] = min_curvature(P,T)
    H  = mean_curvature(P,T);
    K  = gaussian_curvature(P,T);
    k1 = H - max( H.^2-K, zeros(size(P,1),1) ).^0.5;
end