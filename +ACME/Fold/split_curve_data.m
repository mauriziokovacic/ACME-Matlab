function [C] = split_curve_data(CData)
k = [];
for i = 1 : row(CData)
    if(isempty(CData{i}))
        continue;
    end
    k = [k; repmat(i,row(CData{i}.S),1) (1:row(CData{i}.S))'];
end

C = cell(row(k),1);
for n = 1 : row(k)
    i = k(n,1);
    j = k(n,2);
    
    s = CData{i}.S{j};
    e = CData{i}.E(s,:);
    v = unique(e,'stable');
    closed = e(1,1) == e(end,2);
    
    C{n}.P = CData{i}.P(v,:);
    C{n}.N = CData{i}.N(v,:);
    C{n}.D = CData{i}.D(v,:);
    C{n}.W = CData{i}.W(v,:);
    C{n}.T = CData{i}.T(v,:);
    C{n}.B = CData{i}.B(v,:);
    C{n}.E = [(1:numel(v)-1)' (2:numel(v))'];
    if( closed )
        C{n}.E = [C{n}.E; numel(v) 1];
    end
    C{n}.F = i;
    C{n}.t = CData{i}.t{j};
end

end