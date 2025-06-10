function [W] = CPS2Weight(Deformer,KeyFrame,selected)
P = Deformer.Mesh.Vertex;
W = Deformer.Skin.Weight;
e = weight2extremity(W);
W = extractExtremity(W,e);

if(nargin<3)
    selected = (1:row(P))';
end
if(~iscell(KeyFrame))
    KeyFrame = {KeyFrame};
end
Q = cellfun(@(k) Deformer.deform(k),KeyFrame,'UniformOutput',false);
KeyFrame = cellfun(@(k) erase(k,e),KeyFrame,'UniformOutput',false);
n = col(W);

Wi = cell(numel(selected),1);
options = optimoptions('particleswarm','Display','off','UseParallel',true,'UseVectorized',true);
parfor s = 1 : numel(selected)
    disp([num2str(s/numel(selected)),'%']);
    i = selected(s);
    lsq = @(x,q)   sum((x-q).^2,2);
    x   = @(w,k,p) transform_point(compute_transform(KeyFrame{k},w),p,'mat');
    t   = @(w,k)   lsq(x(w,k,repmat(P(i,:),row(w),1)),Q{k}(i,:));
    fun = @(w)     sum(cell2mat(arrayfun(@(k) t(w,k),(1:numel(KeyFrame)),'UniformOutput',false)),2);
    %sum ( || sum_j wT*p - q ||^2 ) 
    Wi{s} = particleswarm(fun,n,[],[],options);
end
for s = 1 : numel(selected)
    i = selected(s);
    W(i,:) = sparse(Wi{s});
end
W = W./sum(W,2);
W = insertExtremity(W,e);
hallelujah();
end