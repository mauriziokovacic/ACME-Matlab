function [ EF, C ] = edge_face_adjacency( T )
t = size(T,1);
i = 1;
j = 2;
k = 3;
I = T(:,i);
J = T(:,j);
K = T(:,k);
E = sort( [I J; J K; K I], 2 );
[C, ia, ic] = unique( E, 'rows', 'stable' );
% C  = unique elements
% ia = position of C elements in E (only first occurrence), size of C
% ic = position of E elements in C, size of E
EF = [ic, repmat([1:t]',3,1)];
Adj = sparse( EF(:,1), EF(:,2), 1, size(C,1), t );

EF = zeros( size(Adj,1), 2 );
for n = 1 : size(Adj,1)
id = find( full(Adj(n,:)) );
if( size(id,2) == 1 )
    EF(n,:) = [id, id];
else
    if( size(id,2)>2)
        id = id(1:2);
    end
    EF(n,:) = id;
end
end


end