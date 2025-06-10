function [out] = forloop(fun,index)
if(isscalar(index))
    index = 1 : index;
end
out = bsxfun(@(i,~) fun(i), index, index);
end