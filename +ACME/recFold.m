function [F] = recFold(W)
F = zeros(size(W));
f = @(x,c) min(x,1-c-x)./max(x,1-c-x);
for i = 1 : col(W)
    Wi = W(:,i);
    Fi = f(Wi,0);
    for j = 1 : col(W)
        Wj = W(:,j);
        Fj = f(Wi,Wj);
        Fj(~isfinite(Fj))=0;
        Fi = max(Fi,Fj); 
    end
    F(:,i) = Fi;
end
F(~isfinite(F))=0;
end