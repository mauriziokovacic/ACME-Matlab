function [ID] = field_discontinuity(dF,T)
I = T(:,1);
J = T(:,2);
K = T(:,3);
% G = normr((dF(I,:)+dF(J,:)+dF(K,:))/3);
% [EF, E] = edge_face_adjacency(T);
% d = dot( G(EF(:,1)), G(EF(:,2)), 2);
% v = find( d > 0.5 );
% I = [E(v,1);E(v,2)];
% I = unique(I,'rows');
Dij = dot( dF(I,:), dF(J,:), 2 );
Djk = dot( dF(J,:), dF(K,:), 2 );
Dki = dot( dF(K,:), dF(I,:), 2 );

Dij = find( Dij<0.2 );
Djk = find( Djk<0.2 );
Dki = find( Dki<0.2 );

ID = unique( [I(Dij);J(Djk);K(Dki)] );

end