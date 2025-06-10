function [Value] = minimum(Data)
Value = Data;
for i = 1 : ndims(Data)
    Value = min(Value);
end
end