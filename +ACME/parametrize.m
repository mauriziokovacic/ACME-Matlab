function [P_] = parametrize(P,T,i)
[PP,~,~,TT] = submesh(P,[],[],T,i);
E = boundary(TT);
e = E(1,:);
Q = E(2:row(E),:);
while(~isempty(Q))
    j = find(Q(:,1)==e(end,2));
    if(isempty(j))
        j = 1;
    end
    j = j(1);
    e = [e;Q(j,:)];
    Q(j,:)=[];
end
E = e;
l = [0;vecnorm3(P(E(:,1),:)-P(E(:,2),:))];
t = cumsum(l)./sum(l);
t = t(1:end-1);
k = unique(E,'stable');
n = numel(k);

L = add_constraints(cotangent_Laplacian(PP,TT),k,[]);

alpha = interp1([0;1],[0;2*pi],t);
% alpha = linspace(0,2*pi,n)';
pp = zeros(size(PP));
pp(k,:) = [cos(alpha) sin(alpha) zeros(n,1)];
pp = linear_problem(L,pp);

% CreateViewer3D();
% display_mesh(pp,[],t,[],'wired');
% line3([pp(e(:,1),:) pp(e(:,2),:)],'Color','r','LineWidth',3);
% 
% qq = pp;
% A = Adjacency(p,t,'comb');
% for nn = 1 : 200
%     ppp = qq;    
%     for ii = 1 : row(pp)
%         if( ismember(ii,k) )
%             continue;
%         end
%         j = find(A(ii,:));
%         v = mean(qq(j,:));
%         ppp(ii,:) = v+0.001*-normr(ppp(ii,:));
%     end
%     qq = ppp;
% end

CreateViewer3D();
display_mesh(PP,[],TT,[],'wired');
% cmap('parula',[],true);
line3([PP(e(:,1),:) PP(e(:,2),:)],'Color','r','LineWidth',3);

CreateViewer3D();
display_mesh(pp,[],TT,[],'wired');
% cmap('parula',[],true);
line3([pp(e(:,1),:) pp(e(:,2),:)],'Color','r','LineWidth',3);

pp = full(ARAP(PP,pp,TT,1));
kdtree = KDTreeSearcher(pp(k,:));
[~,u] = knnsearch(kdtree,pp,'K',1);

% u = vecnorm3(pp);
% [A,tt,L,K] = heat_diffusion_data(pp,TT,k);
% u  = linear_problem(A+tt*L,K);
% gU = normr(compute_gradient(pp,TT,u));
% gU = smooth_direction(gU,Adjacency(pp,TT,'face'),15);
% gU = align_direction(gU,Adjacency(pp,TT,'face'),5);
% gU = normr(gU);
% dU = compute_divergence(pp,TT,gU);
% u  = normalize(linear_problem(L,dU));


CreateViewer3D();
display_mesh(pp,[],TT,u,'wired');
% cmap('parula',[],true);
line3([pp(e(:,1),:) pp(e(:,2),:)],'Color','r','LineWidth',3);
% hold on;
% quiv3(triangle_barycenter(pp,TT),gU,'Color','w');

p_ = zeros(size(PP));

for v = 1 : row(PP)
[x,t] = project_point_on_segment(pp(e(:,1),:),pp(e(:,2),:),pp(v,:));
[~,vv] = min(vecnorm3(pp(v,:)-x));
p_(v,:) = (1-t(vv)).*PP(e(vv,1),:)+t(vv).*PP(e(vv,2),:);
end
P_ = zeros(size(P));
P_(i,:) = p_;

end