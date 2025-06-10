function [I,P] = poly2lin(P)
if(iscell(P))
    f = @(V,i) V{i};
else
    f = @(V,i) V(i,:); 
end
I = cell2mat(arrayfun(@(i) helper(f(P,i),i),(1:row(P))','UniformOutput',false));
[I,P] = edge2ind(I);
end

function [E] = helper(P,i)
E = [reshape(P',numel(P),1) repmat(i,col(P),1)];
end