function [K,varargout] = boundary_condition(P,T,S)
e = @( i, n ) sparse( 1:numel(i) , i, 1, numel(i), n );

A = [];
B = [];
I = [];
for i = 1 : row(S)
    if( isempty(S{i}) )
        continue;
    end
    A = [A;S{i}.A];
    B = [B;S{i}.B];
    I = [I;S{i}.T];
end

K = zeros(row(P),1);
W = mat2cell(sparse(row(P),row(I)),ones(row(P),1));


for i = 1 : row(I)
    t = I(i);
    v = T(t,:)';
    
    W(v) = mat2cell(cell2mat(W(v)) + e([i i i],row(I)),[1 1 1]);
    
    k = max(A(i,:),B(i,:))';
    j = find(k<K(v));
    if( isempty(j) )
        continue;
    end
    v    = v(j);
    K(v) = k(j);
end

if( nargout >= 2 )
    varargout{1} = cell2mat(W);
end
end