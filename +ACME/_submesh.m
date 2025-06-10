function [P,N,UV,T] = _submesh(P,N,UV,T,i,ExtractionType)
if( nargin < 6 )
    ExtractionType = 'vertex';
end
if( isempty(i) )
    return;
end
if( strcmpi(ExtractionType,'face') || strcmpi(ExtractionType,'triangle') )
    i = unique(T(i,:));
end
k = zeros(row(P),1);
P = P(i,:);
if( ~isempty(N) )
    N  = N(i,:);
end
if( ~isempty(UV) )
    UV = UV(i,:);
end
k(i)   = (1:numel(i))';
T      = k(T);
[j,~]  = find(~T);
T(j,:) = [];
end