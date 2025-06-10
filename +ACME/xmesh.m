function [M,T] = xmesh(T,scheme,iter)
n = maximum(T);
M = speye(n,n);
if(iter>0)
    t = T';
    t = t(:);
    M = M(t,:);
    for i = 1 : iter
        e = repelem((0:(row(M)/col(T))-1)',row(scheme.E),1)*col(T) + repmat(scheme.E,row(M)/col(T),1);
        m = sparse(row(e),col(M));
        for j = 1 : col(e)
            m = m+M(e(:,j),:);
        end
        M = (1/col(e))*m;
    end
    T = reshape(1:row(M),scheme.T,row(M)/scheme.T)';
end
end