function [AO] = ambient_occlusion(P,N,T,sigma)
if( nargin < 4 )
    sigma = 0.5*mean_edge_length(P,T);
end
KDT    = KDTreeSearcher(P);
j      = cellfun(@(c) c',rangesearch(KDT,P,sigma),'UniformOutput',false);
i      = cell2mat(arrayfun(@(i) repmat(i,numel(j{i}),1),(1:row(P))','UniformOutput',false));
j(cellfun(@(c) isempty(c),j)) = [];
j      = cell2mat(j);
k      = find(point_plane_distance(P(i,:),N(i,:),P(j,:))<0);
i(k)   = [];
j(k)   = [];
E      = P(j,:)-P(i,:);
x      = logical(sum(E,2));
E(x,:) = normr(E(x,:));
D      = dot(N(i,:),E,2);
j      = find(D<=0.0001);
i(j)   = [];
D(j)   = [];
D      = 1-D;
AO     = accumarray(i,D,[row(P),1],@mean,1);
end