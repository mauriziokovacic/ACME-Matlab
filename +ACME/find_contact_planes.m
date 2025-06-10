function [P_,N_,W_] = find_contact_planes(P,N,T,W,E)
linint = @(Vi,Vj,t) (1-t).*Vi+t.*Vj;
[I,J] = edge2ind(E);
Phi = fold_field(W);

P_ = zeros(size(P));
N_ = zeros(size(N));

E_ = zeros(size(P,1),1);
[~,S] = sort(W,2,'descend');
S = S(:,1);
W_ = closest_fold(W);
delta = zeros(size(P,1),1);

CoR = evalin('base','CoR');
% C   = compute_handle_centers(P,W);
% CoR = W * C;

for i = 1 : size(P,1)
Pi = P(i,:);
Ni = N(i,:);
Wi = W(i,:);
Si = S(i,:);

j = find(W(:,Si));
[~,k(:,1)] = intersect(I,j);
[~,k(:,2)] = intersect(J,j);
j = unique(k);

[X,t] = project_point_on_segment(P(I(j),:),P(J(j),:),Pi);
Wx    = linint(W_(I(j),:),W_(J(j),:),t);
Nx    = linint(N(I(j),:),N(J(j),:),t);
U     = normr(cross(P(I(j),:)-Pi,P(J(j),:)-Pi,2));

Cx = linint(CoR(I(j),:),CoR(J(j),:),t);
u = normr(cross(repmat(Pi-CoR(i,:),numel(j),1),...
                Cx-repmat(CoR(i,:),numel(j),1),...
                2));
v = normr(cross(repmat(CoR(i,:),numel(j),1)-Cx,...
                X-Cx,...
                2));

dX = 1./vecnorm3(X-Pi);
dW = 1./vecnorm3(Wx-Wi);
dN = dot(u,v,2);
dU = (dot(U,linint(repmat(Ni,numel(j),1),Nx,0.5),2));

F  = dW .* dX .* dN;
[~,j] = max(F);
j = j(1);

P_(i,:)  = X(j,:);
N_(i,:)  = normr(cross(U(j,:),linint(u(j,:),v(j,:),0.5),2));
delta(i) = t(j);
E_(i)    = j;


end
% A  = sparse(E_,(1:size(P,1))',1,size(E,1),size(P,1));
% N_ = normr((A*N_)./sum(A,2));


% for n = 1 : size(E,1)
%     e = find(E_==n);
%     if( ~isempty(e) )
%         N_(n,:) = normr(mean(dot(repmat(N_(e(1),:),numel(e),1),N_(e,:),2) .* N_(e,:),1));
%     end
% end

Ei   = zeros(size(P,1),3);
Ej   = zeros(size(P,1),3);
Phii = zeros(size(P,1),1);
Phij = zeros(size(P,1),1);
for e = 1 : size(E,1)
i = find(E_==e);
if( ~isempty(i) )
n = repmat(N_(i(1),:),numel(i),1);
n = normr(dot(n,N_(i,:),2).*N_(i,:));
Ei(E(e,1),:) = Ei(E(e,1),:)+sum(Phi(i).*(1-delta(i)).*n,1);
Ej(E(e,2),:) = Ej(E(e,2),:)+sum(Phi(i).*(0+delta(i)).*n,1);
Phii(E(e,1)) = Phii(E(e,1)) + sum(Phi(i).*(1-delta(i)));
Phij(E(e,2)) = Phij(E(e,2)) + sum(Phi(i).*(0+delta(i)));
end
end
N_ = (Ei(E(:,1),:)+Ej(E(:,2),:))./(Phii(E(:,1))+Phij(E(:,2)));



N_ = N_(E_,:);
% N_ = normr(cross( cross((P-P_),N_,2 ),N_,2));
N_ = reorient_plane(P_,N_,P);

I = E(E_,1);
J = E(E_,2);
W_ = linint(W_(I,:),W_(J,:),delta);
W_ = W_ ./ sum(W_,2);
end