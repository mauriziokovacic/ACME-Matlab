function [F] = closest_fold(W,level,type)
if( nargin < 3 )
    type = 'soft';
end
if( nargin < 2 )
    level = 1;
end
if( level < 1 )
    level = 1;
end
if( level >= size(W,2) )
    level = size(W,2)-1;
end
[S, I] = sort(W,2,'descend');
% dW = W;
% for i = 1 : size(W,1)
%     d = O(i,level);%-O(i,level+1);
%     dW(i,I(i,level)) = d;
%     dW(i,I(i,level+1)) = d;
% end
% dW = W - dW;
% F  = W - dW;
% F  = F ./ sum(F,2);
if( strcmpi(type,'soft') )
    if( level == 1 )
        D = 1;
    else
        D = 1-sum(S(:,1:level-1),2);
    end
    S = S(:,level);
    I = sub2ind(size(W), (1:size(W,1))',I(:,1));

    F = (W./(D-S)).*(D.*0.5);
    F(I) = (D.*0.5);
    [i,~] = find(~isfinite(F));
    F(~isfinite(F))=0;
    F(i,:) = F(i,:)./sum(F(i,:),2);
end

if( strcmpi(type,'hard') )
    dW = W;
    Si = S(:,level);
    i  = find(Si==1);
    Sj = S(:,level+1);
    d  = (Si+Sj)./2;
    J = sub2ind(size(W), (1:size(W,1))',I(:,2));
    I = sub2ind(size(W), (1:size(W,1))',I(:,1));
    dW(I) = d;
    dW(J) = d;
    dW = W - dW;
    F  = W - dW;
    F  = F ./ sum(F,2);
    F(i,:)=W(i,:);
end

F(S(:,level)==1,:)=Inf;

end