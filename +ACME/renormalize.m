function [out] = renormalize(value,min,max)
if(nargin<3)
    max=1;
end
if(nargin<2)
    min=0;
end
if(min>max)
    [min,max]=swap(min,max);
end
out = min + normalize(value).*max;
end