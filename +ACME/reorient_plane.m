function [N] = reorient_plane(P,N,Q)
i = find( point_plane_distance(P,N,Q) < 0 );
N(i,:) = -N(i,:);
end