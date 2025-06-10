function [C] = compute_handle_centers(P,W)
C = ( W' * P ) ./ sum(W,1)';
end