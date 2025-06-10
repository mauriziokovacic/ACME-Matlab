function [P_,N_] = closest_fold_point(P,N,T,R,C)
C = cellfun(@(c) c.P, C,'UniformOutput',false);
C = [C;{cell2mat(C)}];
I = cellfun(@(r) find(r),num2cell(R.I,1),'UniformOutput',false)';

N_ = N;%zeros(size(P));
iter = 5;
F = zeros(row(N),iter);
for n = 1 : iter
    f  = cellfun(@(i,c) E(P(i,:),N_(i,:),c),I,C,'UniformOutput',false);
    F(:,n) = accumarray(cell2mat(I),cell2mat(f))./accumarray(cell2mat(I),1);
    N_ = cellfun(@(i,c) (N_(i,:) + dE(P(i,:),c)),I,C,'UniformOutput',false);
    N_ = normr(accumarray3(cell2mat(I),cell2mat(N_))./accumarray(cell2mat(I),1));
end
P_ = P;
end

function [f] = E(P,N,C)
f = cellfun(@(p,n) sum(dot(repmat(n,row(C),1),C-p,2)),num2cell(P,2),num2cell(N,2),'UniformOutput',false);
f = cell2mat(f);
end

function [df] = dE(P,C)
df = cellfun(@(p) sum(normr(p-C),1),num2cell(P,2),'UniformOutput',false);
df = cell2mat(df);
end



% function [P_,N_,W_] = closest_fold_point(P,T,R,C)
% 
% K = cellfun(@(c) {KDTreeSearcher(interleave(c.P(c.E(:,1),:),(c.P(c.E(:,1),:)+c.P(c.E(:,2),:))*0.5,c.P(c.E(:,2),:)))}, C);
% K = [K;{KDTreeSearcher(cell2mat(cellfun(@(k) k.X,K,'UniformOutput',false)))}];
% I = cellfun(@(w) find(w),num2cell(R.I,1),'UniformOutput',false)';
% 
% J = cellfun(@(i,k) knnsearch(k,P(i,:),'K',1), I,K,'UniformOutput',false);
% X = cellfun(@(k,j) k.X(j,:),K,J,'UniformOutput',false);
% P_ = accumarray3(cell2mat(I),cell2mat(X))./accumarray(cell2mat(I),1);
% 
% ID = cellfun(@(i,c) cellfun(@(pi) closest_segment(pi,c),num2cell(P_(i,:),2),'UniformOutput',false),...
%              I,C,'UniformOutput',false);
% t  = cellfun(@(i,c,id) cellfun(@(pi,id) closest_parameter(pi,c,id),num2cell(P_(i,:),2),num2cell(id,2),'UniformOutput',false),...
%              I,C,ID,'UniformOutput',false);
% N_ = cellfun(@(c,id,tt) lin_int(c.N(c.E(id,1),:),c.N(c.E(id,2),:),tt),I,C,ID,t,'UniformOutput',false);
% N_ = accumarray3(cell2mat(I),cell2mat(N_))./accumarray(cell2mat(I),1);
% W_ = cellfun(@(c,id,tt) lin_int(c.W(c.E(id,1),:),c.W(c.E(id,2),:),tt),I,C,ID,t,'UniformOutput',false);
% W_ = accumarray3(cell2mat(I),cell2mat(W_))./accumarray(cell2mat(I),1);
% end
% 
% function [I] = closest_segment(P,C)
% [~,I] = min(vecnorm3(P-project_point_on_segment(C.P(C.E(:,1),:),C.P(C.E(:,2),:),P)));
% end
% 
% function [t] = closest_parameter(P,C,I)
% [~,t] = project_point_on_segment(C.P(C.E(I,1),:),C.P(C.E(I,2),:),P);
% end
% 
% function [C] = lin_int(A,B,t)
% C = (1-t).*A+t.*B;
% end