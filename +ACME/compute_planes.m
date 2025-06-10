function [P_, N_] = compute_planes(P,N,T,ID,n,gU)
if( nargin < 6 )
    U = [];
end
if( nargin < 5 )
    n = 3;
end
P_ = zeros(size(P));
N_ = zeros(size(N));
Adj = n_ring(P,T,n,ID);
M = (Adj*P+P)./(sum(Adj,2)+1);
for j = 1:numel(ID)
    i = ID(j);
    I = find(Adj(i,:));
    P_(i,:) = M(i,:);
    C = P(I,:)-repmat(M(i,:),numel(I),1);
    C = C' * C;
    [U,~,~] = svd(C);
    N_(i,:) = normr(cross(N(i,:),U(:,1)',2));
end

N_ = align_field(N_,N_,Adj,5);
N_ = align_field(N_,gU,Adj,10);



% P_ = (Adj*P_+P_)./(sum(Adj,2)+1);
% N_ = (Adj*N_+N_)./(sum(Adj,2)+1);
P_ = P_(ID,:);
N_ = N_(ID,:);
end