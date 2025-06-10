function [F] = Phi(W,type)
if( nargin < 2 )
    type = 'slow';
end
if( strcmpi(type,'slow') )
%     F = zeros(row(W),1);
%     for i = 1 : col(W)
%         F = max(phi_i(W(:,i)),F);
%     end
    F = max(phi_i(W),[],2);
end
if( strcmpi(type,'fast') )
    W = sort(W,2,'descend');
    W = W(:,1);
    F = phi_i(W);
end
end