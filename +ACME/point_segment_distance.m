function [ D ] = point_segment_distance( A, B, P )
Q = project_point_on_segment(A,B,P);
D = vecnorm3(P-Q);
end