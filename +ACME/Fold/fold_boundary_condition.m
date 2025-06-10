function [K,varargout] = fold_boundary_condition(P,T,S)
e = @( i, n ) sparse( 1:numel(i) , i, 1, numel(i), n );
K = zeros(row(P),1);
W = sparse(row(P),row(S));
for s = 1 : row(S)
if(~isempty(S{s}))
for t = 1 : row(S{s}.T)
i = T(S{s}.T(t),:)';
k = max(S{s}.A(t,:)',S{s}.B(t,:)');
% K(i) = max(K(i),k);
j = find(k>K(i));
K(i(j)) = k(j);
W(i(j),:) = e(repmat(s,numel(i(j)),1),row(S));
end
end
end
if( nargout >= 2 )
    varargout{1} = W;
end
end