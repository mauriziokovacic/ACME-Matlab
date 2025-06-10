function [St] = extract_fold_triangles(S,n)
t = repmat(struct('A',[],'B',[]),n,1);
for i = 1 : row(S)
    if(isempty(S{i}))
        continue;
    end
    for j = 1 : row(S{i}.T)
        k = S{i}.T(j);
        t(k).A = [t(k).A;S{i}.A(j,:)];
        t(k).B = [t(k).B;S{i}.B(j,:)];
    end
end
St = cell(n,1);
for i = 1 : n
    if(isempty(t(i).A))
        continue;
    end
    St{i}.A = t(i).A;
    St{i}.B = t(i).B;
end
end