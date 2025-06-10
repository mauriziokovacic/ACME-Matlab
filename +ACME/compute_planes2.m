function [p_,n_] = compute_planes2(P,W,degree)
if( nargin < 3 )
    degree = 1;
end
if( degree <= 0 )
    degree = 1;
end
[w,i] = sort(W,2,'descend');
w = full(w(:,degree:degree+1));
i = i(:,degree:degree+1);

c = compute_handle_centers(P,W);
% c = accumarray3(i(:,1), w(:,1)'*P, [size(W,2),1] );
% s = accumarray(i(:,1),w(:,1),[size(W,2),1]);
% c = c ./ s;

cc = (W * c); %( c(i(:,1),:) + c(i(:,2),:) ) ./ 2;
c1 = c(i(:,1),:);
c2 = c(i(:,2),:);
% cc = ( w(:,1) .* c1 + w(:,2) .* c2 ) ./ sum(w,2);
u = w(:,1).*(c1-cc);
v = w(:,2).*(c2-cc);
% n_ = (u-v)/2;
n_ = normr((c1-c2));
% n_ = normr(cross(cross(c1-P,c2-P,2),(0.5*(c1+c2))-P,2));

% d1 = w(:,1).*(c1-P);
% d2 = w(:,2).*(c2-P);
% % i = find( vecnorm3(d1) < vecnorm3(d2) );
% % d1(i,:) = -d1(i,:);
% % d2(i,:) = -d2(i,:);
% n_ = (d1-d2) ./ 2;


% [I,J] = find(W);
% cc = (W * c) ./ sum(W,2);
% % cd = accumarray3(I,(c(J,:)-cc(I,:)),[size(P,1) 1]);
% cd = c(i(:,1),:) - cc;
% cdd = cd;
% cd = normr(cd);
% ww = ones(size(P,1),1);
% for n = 1 : numel(I)
%     ii = I(n);
%     jj = J(n);
%     d  = W(ii,jj) * (c(jj,:)-cc(ii,:));
%     dd = dot(cd(ii,:),normr(d),2);
%     cdd(ii,:) = cdd(ii,:) + dd*d;
%     ww(ii,:) = ww(ii,:) + abs(dd);
% end
% cd = cd ./ ww;
% n_ = cd;

p_ = cc;


% L = cotangent_Laplacian(P,T);
% L = add_constraints(L,id,[]);
% b = sparse(size(W,1),size(W,2));
% b(id,:) = W(id,:);
% w = linear_problem(L,b);
% [p_,n_] = compute_planes2(P,w,1);
% tmp = N_;
% N_ = n_;
% xxx = point_plane_distance(P_,N_,P);
% xx = find(xxx<0);
% N_(xx,:) = -N_(xx,:);
% tmp2 = I;
% I = U;


end