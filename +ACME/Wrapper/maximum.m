function [Value] = maximum(Data)
Value = Data;
for i = 1 : ndims(Data)
    Value = max(Value);
end
end