function [P_,N_,W_,U] = somethingelse(R,P,W,C)
P_ = zeros(size(P));
N_ = zeros(size(P));
W_ = sparse(row(P),col(W));
X = something(R,P,C);
for i = 1 : row(P)
    c = X{i}.C;
    [~,j] = sort(distance(C{c}.P,P(i,:)));
    j = j(1:2);
    P_(i,:) = mean(C{c}.P(j,:)); 
    N_(i,:) = mean(C{c}.N(j,:));
    W_(i,:) = mean(C{c}.W(j,:));
end
W_ = W_./ sum(W_,2);
N_ = reorient_plane(P_,N_,P);
U = 1-normalize(distance(P,P_));
for i = 1 : row(P)
    c = X{i}.C;
    p = mean(C{c}.P);
    n = mean(C{c}.N);
    w = mean(C{c}.W);
    
    P_(i,:) = U(i).*P_(i,:) + (1-U(i)).* p; 
    N_(i,:) = U(i).*N_(i,:) + (1-U(i)).* n;
    W_(i,:) = U(i).*W_(i,:) + (1-U(i)).* w;
end
W_ = W_./ sum(W_,2);
N_ = reorient_plane(P_,N_,P);
U = 1-normalize(distance(P,P_));
end

function [X] = something(R,P,C)
X = cell(row(P),1);
for i = 1 : row(P)
    X{i}.C = [];
    X{i}.D = [];
end

for r = 1 : row(R)
    if(isempty(R{r}.V))
       continue; 
    end
    for v = 1 : numel(R{r}.V)
        i = R{r}.V(v);
        j = [];
        D = Inf;
        for c = 1 : numel(R{r}.C)
            k = R{r}.C(c);
            d = min(distance(P(i,:),C{k}.P));
            if(d<D)
                D = d;
                j = k;
            end
        end
        X{i}.C = [X{i}.C;j];
        X{i}.D = [X{i}.D;D];
    end
end

for i = 1 : row(P)
    [~,j] = min(X{i}.D);
    X{i}.C = X{i}.C(j);
    X{i}.D = X{i}.D(j);
end

end