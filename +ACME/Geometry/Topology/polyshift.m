function [P] = polyshift(P,n)
if(iscell(P))
    f = @(V,i) V{i};
    p = @(V) V;
else
    f = @(V,i) V(i,:); 
    p = @(V) cell2mat(V);
end
P = p(arrayfun(@(i) circshift(f(P,i),n),(1:row(P))','UniformOutput',false));
end