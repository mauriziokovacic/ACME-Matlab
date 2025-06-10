function [Value] = closepow2(N)
Value = pow2(round(log2(N)));
end