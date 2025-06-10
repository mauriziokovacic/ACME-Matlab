function [TID,VID] = optimized_skinning_region_ID(P,T,W,iter)
if( nargin < 4 )
    iter = 2;
end
[TID,~] = skinning_region_ID(T,W);
S = skinning_region_area(P,T,TID);
[~,I] = sort(S,'descend');

A = Adjacency([],T,'face');
for n = 1 : iter
    for m = 1 : numel(I)
    S = find(TID==I(m));
    
        for k = 1 : size(S,1)
            i = S(k);
            t = TID(i);
            j = find(A(i,:));
            if( numel(j) > 0 )
                if( numel(j) == 3 )
                    s = sum( TID(j) == t );  
                    if( s < 2 )
                        r = unique(TID(j)');
                        [~,rr] = max( sum(TID(j)==r,1) );
                        r = r(rr);
                        TID(i) = r;
                    end
                end
            end
        end
    end
end

[I,J,K] = tri2ind(T);
VID = sparse([I;J;K],repmat(TID,3,1),1,size(W,1),size(W,2));

end