function [ D ] = mesh_distance( A, B )
D = sum((A.P-B.P).^2, 2).^0.5;
end