function [y] = barrier_function(x,t)
y       = zeros(size(x));
i       = find(x>0&x<t);
y(i)    = 1./g(x(i),t)-1;
y(x<=0) = inf;
end

function [y] = g(x,t)
y = (x.^3 ./ t^3)-3*(x.^2 ./ t^2)+3* (x ./ t);
end