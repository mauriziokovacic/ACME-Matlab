function [D] = distance(A,B,p,dim)
if(nargin<4)
    dim=2;
end
if((nargin<3)||isempty(p))
    p = 2;
end
if( size(A,p-1)==1 || size(B,p-1)==1 || size(A,p-1)==size(B,p-1) )
    D = vecnorm(A-B,p,dim);
    return;
end
% [A,B] = prepare_broadcast(A,B,dim);
% D = min(vecnorm(A-B,p,ndims(A)),[],2);
D = vecnorm(B(knnsearch(KDTreeSearcher(B),A,'K',1),:)-A,p,dim);
end