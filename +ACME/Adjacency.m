function [ A ] = Adjacency( P, T, type, varargin )
if( nargin < 3 )
    type = 'comb';
end
n = row(P);
if( strcmp( type, 'comb' ) || strcmp( type, 'cosine' ) || strcmp( type, 'length' ) )
    if( isedge(T) )
        E = T;
    else
        E = poly2edge(T);
    end
    E = unique(sort(E,2),'rows');
    E = [E; fliplr(E)];
    if( strcmp( type, 'comb' ) )
        A = sparse( E(:,1), E(:,2), 1, n, n );
        return;
    end
    if( strcmp( type, 'cosine' ) ) 
        N = varargin{1};
        A = sparse( E(:,1), E(:,2), dot(N(E(:,1),:),N(E(:,2),:),2), n, n );
        return;
    end
    if( strcmp( type, 'length' ) ) 
        A = sparse( E(:,1), E(:,2), vecnorm3(P(E(:,1),:)-P(E(:,2),:)), n, n );
        return;
    end
end

if( strcmp( type, 'cot' ) ) 
    if(~istri(T))
        error('Polygons must be all triangles.');
    end
    T               = poly2tri(T);
    [I,J,K]         = tri2ind(T);
    [CTi, CTj, CTk] = triangle_cotangent(P,T);
    A               = 0.5 * sparse([I;J;K;J;K;I],...
                                   [J;K;I;I;J;K],...
                                   [CTk;CTi;CTj;CTk;CTi;CTj],...
                                   n,n);
    return
end

if( strcmp( type, 'face' ) )
    [E,F]      = poly2edge(T);
    [E, ~, ie] = unique(sort(E,2), 'rows' );
    E = (1:row(E))';
    A = sparse(E(ie),F,1,numel(E),row(T));
    A = A'*A;
    A(sub2ind(size(A),1:row(T),1:row(T)))=0;
    return
end

if( strcmp( type, 'skin' ) )
    E = unique( sortrows( sort( [I J; J K; K I], 2 ) ), 'rows' );
    E = [E; fliplr(E)];
    A = sparse( E(:,1), E(:,2), vecnorm(varargin{1}(E(:,1),:)-varargin{1}(E(:,2),:),2,2), n, n );
end

if( strcmp( type, 'deform' ) )
    d = skinning_regions(varargin{1});
    E = unique( sortrows( sort( [d(I) d(J); d(J) d(K); d(K) d(I)], 2 ) ), 'rows' );
    E = [E; fliplr(E)];
    A = sparse( E(:,1), E(:,2), 1, size(varargin{1},2), size(varargin{1},2) );
end
end