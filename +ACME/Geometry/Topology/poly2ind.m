function [varargout] = poly2ind(P)
n = min([nargout col(P)]);
for i = 1 : n
    varargout{i} = P(:,i);
end
for i = i+1 : nargout
    varargout{i} = [];
end
end