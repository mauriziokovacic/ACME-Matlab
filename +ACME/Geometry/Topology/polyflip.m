function [P] = polyflip(P)
if(iscell(P))
    f = @(V,i) V{i};
    p = @(V) V;
else
    f = @(V,i) V(i,:); 
    p = @(V) cell2mat(V);
end
P = p(arrayfun(@(i) fliplr(f(P,i)),(1:row(P))','UniformOutput',false));
end