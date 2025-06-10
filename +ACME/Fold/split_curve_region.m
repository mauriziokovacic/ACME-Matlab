function [C] = split_curve_region(P,T,W,R,CData)
S = [];
for s = 1 : row(CData)
    if(isempty(CData{s}))
        continue;
    end
    w = CData{s}.F;
    t = CData{s}.T;
    j = find(R.W==w);
    i = unique(T(t,:));
    r = R.I(i,:);
    r = r(:,j);
    [~,r] = find(r);
    r = unique(r);
    r = j(r);
    S = [S; r repmat(s,numel(r),1)];
end

C = cell(col(W),1);
while(~isempty(S))
    s = S(1,:);
    i = find(s(1)==S(:,1));
    j = S(i,2);
    S(i,:) = [];
    I = s(1);%CData{j(1)}.F;
    C{I}.P = [];
    C{I}.N = [];
    C{I}.D = [];
    C{I}.W = [];
    C{I}.B = [];
    C{I}.T = [];
    C{I}.E = [];
    C{I}.t = [];
    C{I}.F = [];
    C{I}.R = [];
    C{I}.S = cell(numel(j),1);
    for n = 1 : numel(j)
        offset = row(C{I}.P);
        C{I}.P = [C{I}.P;CData{j(n)}.P];
        C{I}.D = [C{I}.D;CData{j(n)}.D];
        C{I}.N = [C{I}.N;CData{j(n)}.N];
        C{I}.W = [C{I}.W;CData{j(n)}.W];
        C{I}.T = [C{I}.T;CData{j(n)}.T];
        C{I}.B = [C{I}.B;CData{j(n)}.B];
        C{I}.E = [C{I}.E;CData{j(n)}.E+offset];
        C{I}.t = [C{I}.t;CData{j(n)}.t];
        C{I}.F = CData{j(n)}.F;
        C{I}.R = s(1);
        C{I}.S{n} = (1:row(CData{j(n)}.P))'+offset;
        x = find(C{I}.S{n}>row(C{I}.E),1);
        if(~isempty(x))
            C{I}.S{n} = C{I}.S{n}(1:x-1);
        end
    end
end
C = erase_empty(C);

c = cellfun(@(c) cell2mat(cellfun(@(i) mean(c.P(c.E(i,:),:)),c.S,'UniformOutput',false)), C,'UniformOutput',false);
for r = 1 : row(C)
    C{r}.C = c{r};
end
for c = 1 : row(C)
    C{c}.U = zeros(size(C{c}.P));
    for s = 1 : row(C{c}.S)
        i = unique(C{c}.E(C{c}.S{s},:));
        C{c}.U(i,:) = C{c}.P(i,:)-C{c}.C(s,:);
    end
end

end