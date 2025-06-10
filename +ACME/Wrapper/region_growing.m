function [V,S] = region_growing(P,T,F,seed,fun)
n = row(P);
V = false(n,1);
S = false(n,1);
A = topoAdjacency(T);
N = arrayfun(@(i) find(A(i,:))',(1:n)','UniformOutput',false);

Q = seed;
while(~isempty(Q))
    [k,Q] = pop(Q);
    if(~V(k))
        V(k) = true;
        if(fun(F(k)))
            S(k) = true;
            Q = push(Q,N{k});
        end
    end
end

end

function [k,Q] = pop(Q)
k = Q(1);
Q(1) = [];
end

function [Q] = push(Q,k)
Q = [Q;k];
end