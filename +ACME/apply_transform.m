function [ PP, NN ] = apply_transform(P,N,Tr)
if( size(Tr,2) == 12 )
transform_point = @(t,p) ...
 [bsxfun(@plus,dot(t(:,1:3),p,2),t(:,4)) ...
  bsxfun(@plus,dot(t(:,5:7),p,2),t(:,8)) ...
  bsxfun(@plus,dot(t(:,9:11),p,2),t(:,12))];
 
transform_normal = @(t,n) [dot(t(:,1: 3),n,2) dot(t(:,5: 7),n,2) dot(t(:,9:11),n,2)];
end
if( size(Tr,2) == 9 )
transform_point = @(t,p) ...
    [dot(t(:,1: 3),[p ones(size(p,1),1)],2) ...
     dot(t(:,4: 6),[p ones(size(p,1),1)],2)];

transform_normal = @(t,n) [dot(t(:,1: 2),n,2) dot(t(:,4: 5),n,2)];
end
if( size(Tr,1) == 1 )
    Tr = repmat(Tr,size(P,1),1);
end
if( isempty(P) )
    PP = [];
else
PP = transform_point(Tr,P);
end
if( isempty(N) )
    NN = [];
else
    NN = transform_normal(Tr,N);
end
end
