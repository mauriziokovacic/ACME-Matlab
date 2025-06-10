function [ D ] = point_plane_distance( P, N, Q )
D = sum(N.*(Q-P),2);
end