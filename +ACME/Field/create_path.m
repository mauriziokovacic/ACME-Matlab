function [C] = create_path(P,T,v,G,F,type)
if( nargin < 6 )
    type = 'vertex';
end
if( nargin < 5 || isempty(F) )
    F = false(row(T),1);
end
[i,j] = find(Adjacency(P,T,'face'));
A = cell(row(T),1);
for n = 1 : numel(i)
    A{i(n)} = [A{i(n)};j(n)];
end
C = cell(numel(v),1);
if( ispoolactive() )
    parfor i = 1 : numel(v)
        C{i} = extract_path(P,T,A,v(i),G,F);
    end
else
    for i = 1 : numel(v)
        C{i} = extract_path(P,T,A,v(i),G,F,type);
    end
end
end

function [C] = extract_path(P,T,A,v,G,F,type)
visited = false(row(T),1);
[I,J,K] = tri2ind(T);
Pi = P(I,:);
Pj = P(J,:);
Pk = P(K,:);
C = P(v,:);
[Q,~] = find(T==v,1);
while((~isempty(Q))&&(row(C)<200))
    t    = Q(1);
    Q(1) = [];
    if( visited(t) )
        continue;
    end
    B = barycentric_coordinates(P,T(t,:),C(end,:));
    if( BC_outside(B) )
        continue;
    end
    if( F(t) )
        break;
    end
    visited(t) = true;
    g    = G(t,:);
    X    = ray_segment_intersection(C(end,:),g,[Pi(t,:);Pj(t,:);Pk(t,:)],[Pj(t,:);Pk(t,:);Pi(t,:)]);
    [i,~] = find(isnan(X));
    X(i,:) = [];
    X = uniquetol(X,0.0001,'ByRows',true);
    if(~isempty(X))
        X = X(find( vecnorm3(X-C(end,:)) > 0.0001,1),:);
        C = [C;X];
        Q = [Q;A{t}];
    end
end
end