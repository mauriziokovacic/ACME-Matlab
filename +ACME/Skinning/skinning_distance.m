function [D,varargout] = skinning_distance(Wi,Wj,p,fold_function)
if( nargin < 4 )
    fold_function = @(w) fold_field(w,1,'soft');
end
if( nargin < 3 )
    p = 0.5;
end
D = [];
if( size(Wi,1)~=size(Wj,1) )
    return;
end
if( ( size(Wi,2) == 1 ) && ( size(Wj,2) == 1 ) )
    Fi = Wi;
    Fj = Wj;
else
    Fi = fold_function(Wi);
    Fj = fold_function(Wj);
end
n = (p^p)/((p+1)^(p+1));
D = ((Fi.*Fj).*abs(Fi-Fj).^p)./n;
if( nargout >= 2 )
varargout{1} = min(D);
end
if( nargout >= 3 )
varargout{2} = max(D);
end
if( nargout >= 4 )
varargout{3} = mean(D);
end
if( nargout >= 5 )
varargout{4} = median(D);
end
end