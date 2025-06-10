function [W] = weight2normalized(W,k)
if(nargin<2)
    k = [];
end
W = clamp(W,0,1);
if(~isempty(k))
    if(~iscell(k))
        k = num2cell(k,2);
    end
    if(row(k)==1)
        k = repmat(k,row(W),1);
    end
    i = cellfun(@(j) setdiff((1:col(W))',j),k,'UniformOutput',false);
    for x = 1 : row(W)
        s = sum(W(x,i{x}),2);
        if(s>0)
            W(x,i{x}) = (W(x,i{x})./s)*(1-sum(W(x,k{x}),2));
        end
    end
end
W = W./sum(W,2);
end