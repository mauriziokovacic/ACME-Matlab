function [e] = unitVector(i,n)
e = sparse( 1:numel(i) , i, 1, numel(i), n );
end