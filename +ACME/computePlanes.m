function [P,N,W] = computePlanes(S,FC)
P = [];
N = [];
W = [];
tic
for c = 1 : numel(FC)
    C = FC(c);
    h = C.Handle;
    p = getPoint(C);
    t = tangent(C);
    w = surfaceData(C,C.Skin.Weight);
    w = [w sparse(row(p),1)];
    W = [W;w];
    w = sparse(row(w),col(w));
    w(:,h) = 1;
    [x,i] = project_on_bone(S,p);
    x = cell2mat(arrayfun(@(k) w(k,i)*x{k},(1:row(p))','UniformOutput',false));
    n = normr(p-x);
%     n = normr(cross(t,n,2));
    P = [P;p];
    N = [N;n];
end
toc
end

% function [P,N] = computePlanes(S)
% X = referenceJointPosition(S);
% U = referenceJointOrientation(S);
% P = X;
% N = U;
% for i = 1 : numel(S.JointList)
%     p = predecessors(S.Graph,i);
%     c = successors(S.Graph,i);
%     if(isempty(p))
%         if(isempty(c))
%             
%         else
%             P(i,:) = mean(X(c,:));
%             N(i,:) = normr(sum(U(c,:),1));
%         end
%     else
%         if(isempty(c))
%             P(i,:) = X(p,:);
%             N(i,:) = U(p,:);
%         else
%         end
%     end
% end
% end

% P = referenceJointPosition(obj);
% N = zeros(numel(obj.JointList),3);
% for i = 1 : numel(obj.JointList)
%     p = predecessors(obj.Graph,i);
%     c = successors(obj.Graph,i);
%     if(~isempty(p))
%         x = P(p,:);
%     else
%         x = P(i,:);
%     end
%     if(~isempty(c))
%         N(i,:) = sum(P(c,:)-x,1);
%     else
%         N(i,:) = sum(P(i,:)-x,1);
%     end
% end
% N = normr(N);