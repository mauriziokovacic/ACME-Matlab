function [s] = skinning_similarity(Wp,Wv,sigma)
% Assume Wp is a 1xm sparse vector
% Assume Wv is a nxm sparse matrix
if(nargin<3)
    sigma = 0.1;
end
j = find(Wp);
v = find(sum(Wp.*Wv,2));
s = zeros(row(Wv),1);
for n = 1:numel(v)
    i = v(n);
    s(i) = SimilarityFcn(Wp,Wv(i,:),sigma,j,find(Wv(i,:)));
end
end

function [s] = SimilarityFcn(Wp,Wv,sigma,j,k)
i = combvec(j,k)';
i(i(:,1)==i(:,2),:) = [];
j = i(:,1);
k = i(:,2);
s = full(sum(Wp(j).*Wp(k).*Wv(j).*Wv(k).*...
             exp(-((Wp(j).*Wv(k)-Wp(k).*Wv(j)).^2)./(sigma.^2))));
end