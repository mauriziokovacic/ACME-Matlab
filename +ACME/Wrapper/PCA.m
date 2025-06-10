function [ B, varargout ] = PCA( P )
B = barycenter( P );
M = P - B;
C = M'*M;
[~,S,V] = svd(C);
V = V';
if( nargout >= 2 )
    varargout{1} = V;
end
if( nargout >= 3 )
    varargout{2} = diag(S);
end
% if( nargout >= 3 )
%     varargout{1} = V(1,:);
%     varargout{2} = V(2,:);
% end
% if( nargout >= 4 )
%     varargout{3} = V(3,:);
% end
end