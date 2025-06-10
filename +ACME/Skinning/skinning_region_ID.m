function [TID,VID] = skinning_region_ID(T,W)
[~,TID] = sort(vertex2face(W,T),2,'descend');
TID = TID(:,1);
[I,J,K] = tri2ind(T);
VID = sparse([I;J;K],repmat(TID,3,1),1,row(W),col(W));
end