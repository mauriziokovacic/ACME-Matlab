function [E,I] = poly2edge(P)
E = [];
I = [];
if(isempty(P))
    return;
end
P = poly2equal(P);
E = unique([reshape(P(:,reshape(circshift(repelem(1:col(P),1,2),-1,2),...
                                2,col(P)))',...
                    2,numel(P))',...
    repelem((1:row(P))',col(P),1)],'stable','rows');
I = E(:,end);
E = E(:,1:end-1);
end


% function [E,I] = poly2edge(P)
% E = [];
% I = [];
% if(isempty(P))
%     return;
% end
% 
% if(iscell(P))
%     f = @(V,i) V{i};
% else
%     f = @(V,i) V(i,:); 
% end
% E = cell2mat(arrayfun(@(i) helper(f(P,i),i),(1:row(P))','UniformOutput',false));
% I = E(:,end);
% E = E(:,1:end-1);
% end
% 
% function [E] = helper(P,n)
% i = (1:row(P))';
% j = (1:col(P))';
% k = mod(j,col(P))+1;
% I = sub2ind(size(P),repelem(i,col(P),1),repmat(j,row(P),1));
% J = sub2ind(size(P),repelem(i,col(P),1),repmat(k,row(P),1));
% E = [P(I)' P(J)' repmat(n,numel(I),1)];
% end