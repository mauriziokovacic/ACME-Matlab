function [W] = poly2wedge(P)
if(iscell(P))
    f = @(data,i) data{i};
else
    f = @(data,i) data(i,:);
end
W = cell2mat(arrayfun(@(i) helper(f(P,i)),(1:row(P))','UniformOutput',false));
end

function [W] = helper(P)
n = col(P);
P = circrepeat(P,2,2);
t = (1:n)';
t = [t t+1 t+2];
W = P(t);
end