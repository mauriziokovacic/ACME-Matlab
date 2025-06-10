function [n] = dimension(Data)
n = size(Data);
if( prod(n) <= 1 )
    n = prod(n);
else
    n = numel(n);
end
end