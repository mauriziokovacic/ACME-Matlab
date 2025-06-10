function [C] = compute_CoR(P,W,degree)
if( nargin < 3 )
    degree = 1;
end
if( degree <= 0 )
    degree = 1;
end
X = compute_handle_centers(P,W);
% [w,i] = sort(W,2,'descend');
% w = full(w(:,degree:degree+1));
% i = i(:,degree:degree+1);
% C = ( w(:,1) .* X(i(:,1),:) + w(:,2) .* X(i(:,2),:) ) ./ sum(w,2);
C = W*X;
end