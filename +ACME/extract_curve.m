function [C] = extract_curve(A,B,N,T,W,S)
ID = unique(S);
C = cell(size(W,2),1);
for s = 1 : numel(ID)
    i = find(S==ID(s));
    i = i(vecnorm3(A(i,:)-B(i,:))>0.0001);
    P = A(i,:);
    Q = B(i,:);
    n = N(i,:);
    t = T(i,:);
    w = W(i,:);
    E = zeros(size(P,1),2);
    for i = 1 : size(P,1)
        j = find( vecnorm3(repmat(Q(i,:),size(P,1),1)-P) < 0.0001 );
        if( isempty(j) )
            j = i;
        else
            j = j(1);
        end
        E(i,:) = [i j];
    end
    C{ID(s)}.P = P;
    C{ID(s)}.N = n;
    C{ID(s)}.W = w;
    C{ID(s)}.E = E;
    C{ID(s)}.T = t;
end

for c = 1 : size(C,1)
    if( ~isempty(C{c}) )
        id = 1;
        p = 1;
        s = [];
        e = (1:size(C{c}.E,1))';
        while( ~isempty(e) )
            s = [s;p];
            e = setdiff(e,p);
            p = C{c}.E(p,2);
            if( p == s(1) ) 
                C{c}.S(id)   = {s};
                C{c}.C(s,:) = repmat(mean(C{c}.P(s,:)),numel(s),1);
                if( ~isempty(e) )
                    p = e(1);
                    s = [];
                    id = id+1;
                end
            end
        end
%         C{c}.S = {(1:size(C{c}.P,1))'};
%         C{c}.C = repmat(mean(C{c}.P),size(C{c}.P,1),1);
    end
end

end