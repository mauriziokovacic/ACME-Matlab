function [C] = find_curve(P,N,T,W,S)
C = cell(size(S));
parfor s = 1 : size(S,1)
    if( isempty(S{s}) )
        continue;
    end
    
    Bi = [S{s}.A;S{s}.B];
    Ti = repmat(S{s}.T,2,1);
    Pi = from_barycentric(P,T,Ti,Bi);
    E = [(1:row(S{s}.A))' (1:row(S{s}.A))'+row(S{s}.A)];
    [Pi,ia,ic] = uniquetol(Pi,0.0001,'ByRows',true);
    Bi = Bi(ia,:);
    Ti = Ti(ia,:);
    E = ic(E);
    E(E(:,1)==E(:,2),:) = [];
    Ni = from_barycentric(N,T,Ti,Bi);
    Wi = from_barycentric(W,T,Ti,Bi);
    
    [E,Si,t] = find_param(Pi,E);

    C{s}.B = Bi;
    C{s}.T = Ti;
    C{s}.E = E;
    C{s}.P = Pi;
    C{s}.W = Wi;
    C{s}.S = Si;
    C{s}.t = t;
    [C{s}.D,C{s}.N] = find_symmetry(Pi,Ni,E);
end
end

function [E,I,T] = find_param(P,E)
% find possible roots
R = [];
% [~,R] = duplicated(E(:,1));
R = [R;find(~ismember(E(:,1),E(:,2)))];


I = [];
if( isempty(R) )
    [~,R] = duplicated(E(:,1));
    R = setdiff(1:row(E),R);
    R = R(1);
end

e = E(R(1),:);
Q = E(setdiff(1:row(E),R(1)),:);
R(1) = [];
first = 1;
while(~isempty(Q))
    j = find(Q(:,1)==e(end,2));
    if(e(end,2)==e(first,1))
        I = [I;{(first:row(e))'}];
        first = row(e)+1;
    end
    if(isempty(j))
        I = [I;{(first:row(e))'}];
        first = row(e)+1;
        if(isempty(R))
            j = 1;
        else
            j = find((Q(:,1)==E(R(1),1))&(Q(:,2)==E(R(1),2)));
            R(1) = [];
            if(isempty(j))
                j = 1;
            end
        end
    end
    j = j(1);
    e = [e;Q(j,:)];
    Q(j,:)=[];
end
I = [I;{(first:row(e))'}];
I = erase_empty(I);
E = e;

T = cell(row(I),1);
for i = 1 : row(I)
    L    = [0;vecnorm3(P(E(I{i},1),:)-P(E(I{i},2),:))];
    T{i} = cumsum(L)./sum(L);
end

end

