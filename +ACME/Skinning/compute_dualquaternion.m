function [DQ] = compute_dualquaternion( T, W )
T  = mat2dq(T);
DQ = W * T;

% DQ = zeros(row(W),8);
% if(false)%ispoolactive())
%     parfor i = 1 : row(W)
%         DQ(i,:) = compute(T,W(i,:))
%     end
% else
%     for i = 1 : row(W)
%         DQ(i,:) = compute(T,W(i,:));
%     end
% end

DQ = normalized_dualquaternion(DQ);
end

function [DQ] = compute(T,W)
% [~,j,w] = find(W);
% S       = dotN(T(j(1),:),T(j,:));
% DQ      = sum( w * ( sign_of(S) .* T(j,:)) , 1 );

i  = find(W);
w  = W(i)';

[~,j] = sort(w,'descend');
i = i(j);

S  = sign_of(dotN(T(i(1),:),T(i,:)));
DQ = sum( W(i)' .* S .* T(i,:), 1);
end