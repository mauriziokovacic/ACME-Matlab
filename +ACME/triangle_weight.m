function [W] = triangle_weight(P,T,F,type)
if( nargin < 4 )
    type = 'avg';
end
I = T(:,1);
J = T(:,2);
K = T(:,3);
if( strcmp(type,'avg') )
W = ones(3*size(T,1),1);
end
if( strcmp(type,'angle') )
Eij = P(J,:)-P(I,:);
Ejk = P(K,:)-P(J,:);
Eki = P(I,:)-P(K,:);
W = [acos(dot(Eij,-Eki,2)); acos(dot(Ejk,-Eij,2)); acos(dot(Eki,-Ejk,2))];
end
if( strcmp(type,'area') )
W = repmat(triangle_area(P,T),3,1);
end
if( size(F,1) == size(P,1) )
W = [F(I);F(J);F(K)] .* W;
end
if( size(F,1) == size(T,1) )
W = [F;F;F] .* W;
end
end