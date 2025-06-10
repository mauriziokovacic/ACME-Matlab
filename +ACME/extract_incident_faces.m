function [PP,TT,varargout] = extract_incident_faces(type,id,P,T,varargin)
I=T(:,1);
J=T(:,2);
K=T(:,3);

if( strcmp(type,'t') || strcmp(type,'f') || strcmp(type,'face') || strcmp(type,'triangle') )
    i = T(id,1);
    j = T(id,2);
    k = T(id,3);
    [ti,~] = find( I==i | I==j | I==k );
    [tj,~] = find( J==i | J==j | J==k );
    [tk,~] = find( K==i | K==j | K==k );
end

if( strcmp(type,'v') || strcmp(type,'p') || strcmp(type,'vertex') || strcmp(type,'point') )
    [ti,~] = find(I==id);
    [tj,~] = find(J==id);
    [tk,~] = find(K==id);
end

t = sort([ti;tj;tk]);
v = unique([I(t);J(t);K(t)]);
PP = P(v,:);
TT = T(t,:);

for n = 1 : numel(v)
TT( find( TT(:,1) == v(n) ), 1 ) = n;
TT( find( TT(:,2) == v(n) ), 2 ) = n;
TT( find( TT(:,3) == v(n) ), 3 ) = n;
end

if( nargout > 2 )
    for n = 1 : nargout-2
        if( size(varargin{n},1) == size(P,1) )
            varargout{n} = varargin{n}(v,:);
        end
        if( size(varargin{n},1) == size(T,1) )
            varargout{n} = varargin{n}(t,:);
        end
    end
end
end