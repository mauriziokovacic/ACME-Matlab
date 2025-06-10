function [V] = clamp(A,Min,Max)
V = A;
% [i,~] = find(V<min);
% V(i,:) = repmat(min,numel(i),1);
% [i,~] = find(V>max);
% V(i,:) = repmat(max,numel(i),1);
if(isscalar(Min))
    V(V<Min)=Min;
else
    for i = 1 : numel(Min)
        [j,~] = find(V(:,i)<Min(i));
        V(j,i) = Min(i);
    end
end
if(isscalar(Max))
    V(V>Max)=Max;
else
    for i = 1 : numel(Max)
        [j,~] = find(V(:,i)>Max(i));
        V(j,i) = Max(i);
    end
end
end