function [W] = limit_weights(W,K)
if((nargin<2)||isempty(K))
    K = min(col(W),4);
end
if(k<=0)
    W = sparse(row(W),col(W));
    return;
end
[w,j] = sort(W,2,'descend');
w     = w(:,1:K);
j     = j(:,1:K);
i     = repmat((1:row(W))',K,1);
% w     = reshape(w,numel(w),1);
% j     = reshape(j,numel(j),1);
W     = sparse(i,j(:),w(:),row(W),col(W),numel(w));
W     = W./sum(W,2);
end