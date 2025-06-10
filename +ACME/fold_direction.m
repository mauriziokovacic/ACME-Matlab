function [N_] = fold_direction(P,N,ID,sigma,phi)
if( nargin < 5 )
    phi = -0.1;
end
if( nargin < 4 )
    sigma = 1;
end

N_ = zeros(numel(ID),3);
parfor v = 1 : numel(ID)
    p_ = P(ID(v),:);
    n_ = N(ID(v),:);
    D  = vecnorm3(P-repmat(p_,size(P,1),1));
    A  = dot(N,repmat(n_,size(P,1),1),2);
    i = intersect(find(D<sigma),find(A>phi));
    N_(v,:) = sum(A(i,:).*N(i,:),1)./sum(abs(A(i,:)),1);
end
N_ = normr(N_);

end