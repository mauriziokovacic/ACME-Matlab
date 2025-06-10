function [W] = extractExtremity(W,i)
if(nargin<2)
    i = weight2extremity(W);
end
W = W(:,setdiff((1:col(W))',i));
end