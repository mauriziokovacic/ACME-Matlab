function [T_,N_] = find_symmetry(P,N,E,varargin)
f = @(n,e) accumarray3([e(:,1);e(:,2)],[n;n],[size(P,1),1]);
T_ = P(E(:,2),:)-P(E(:,1),:);
N_ = normr(cross(T_,N(E(:,1),:)+N(E(:,2),:),2));
T_ = normr(f(T_,E));
N_ = normr(f(N_,E));

Ei = [E(:,1);E(:,2)];
Ej = [E(:,2);E(:,1)];
Adj = sparse(Ei,Ej,vecnorm3(P(Ei,:)-P(Ej,:)),size(P,1),size(P,1));

sigma = 0.8;
iter  = 10;
for i = 1 : iter
%     N_ = (1-sigma).*N_+sigma.*Adj*N_;
    N_ = N_+sigma.*Adj*N_;
end

N_ = normr(N_);
end