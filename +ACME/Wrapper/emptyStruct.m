function [s] = emptyStruct(s)
s = fieldnames(s)';
s{2,1} = [];
s = struct(s{:});
end