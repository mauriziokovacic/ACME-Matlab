function [ I ] = vertex_discontinuity( T, G )
[EF, E] = edge_face_adjacency(T);
d = dot( G(EF(:,1)), G(EF(:,2)), 2);
v = find( abs(d) < 0.05 );
I = [E(v,1);E(v,2)];
I = unique(I,'rows');
end