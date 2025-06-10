function [ F, varargout ] = fold_field( W, level, type )
[O, I] = sort(W,2,'descend');
if( nargin < 3 )
    type = 'soft';
end
if( nargin < 2 )
    level = 1;
end
if( level < 1 )
    level = 1;
end
if( level >= size(W,2) )
    level = size(W,2)-1;
end

A = O(:,level);
if( strcmpi(type,'soft') )
    B = sum(O(:,(level+1):end),2);
end
if( strcmpi(type,'hard') )
    B = O(:,level+1);
end

Wi = max(A,B);
Wj = min(A,B);

F = Wj./Wi;
F( isnan(F) ) = 0;

if( nargout - 1 == 0 )
    return;
end

if( nargout >= 2 )
    varargout{1} = I(:,level);
end

if( nargout >= 3 )
V = [zeros(size(W,1),1) cumsum(O(:,1:end-1),2)];
V = 1-V(:,level);
w = V-O(:,level);



% F = (1-min(1-(W.^2),[],2));
% [M,I] = max(W,[],2);
% w = 1-full(M);
dF    = -W;
i     = sub2ind(size(W),(1:size(W,1))',I(:,level));
dF(i) = w;


if( level-1>0 )
r = repmat([1:size(W,1)]',level-1,1);
c = I(:,1:level-1);
c = reshape(c,size(W,1)*size(c,2),1);
i = sub2ind(size(W),r,c);
dF(i)=0;
end

varargout{2}=dF;

end

end