function [G] = curve_sample(Ci, Cj, n, varargin)
t       = linspace(0,1,n);
[P,N,T,W] = Ci.fetchData({'Point','Normal','Tangent','Weight'},t,varargin{:});

P = P(1:end-1,:);
N = N(1:end-1,:);
T = T(1:end-1,:);
W = W(1:end-1,:);
L = Laplacian(circshift(speye(row(P)),1,2)+circshift(speye(row(P)),-1,2));
% T = (speye(size(L))+L)\T;
T = implicit_smoothing(T,L,0.5,3);

G = ContactProxy('Point',  zeros(numel(Cj), n, col(P)),...
                 'Normal', zeros(numel(Cj), n, col(N)),...
                 'Weight', zeros(numel(Cj), n, col(W)),...
                 'Value',  zeros(numel(Cj)+1, n, 2));

for j = 1 : numel(Cj)
    for i = 1 : n-1
        [Q,U,w] = point2curve(P(i,:), T(i,:), Cj(j), varargin{:});
        G.Point(j,i,:)  = reshape(Q,1,1,col(P));
        G.Normal(j,i,:) = reshape(U,1,1,col(N));
        G.Weight(j,i,:) = reshape(w,1,1,col(W));
    end
    G.Point(j,end,:)  = G.Point(j,1,:);
    G.Normal(j,end,:) = G.Normal(j,1,:);
    G.Weight(j,end,:) = G.Weight(j,1,:);
end
G.Point  = cat(1,G.Point(1:3,:,:),reshape([P;P(1,:)],1,n,col(P)),G.Point(4:6,:,:));
G.Normal = cat(1,G.Normal(1:3,:,:),reshape([N;N(1,:)],1,n,col(N)),G.Normal(4:6,:,:));
G.Weight = cat(1,G.Weight(1:3,:,:),reshape([W;W(1,:)],1,n,col(W)),G.Weight(4:6,:,:));
G.update();
% u     = numel(Cj)+1;
% v     = n;
% G     = griddedInterpolant({linspace(-1,1,u),linspace(0,1,v),1:3},X,'spline','nearest');
% P     = G({linspace(-1,1,u),linspace(0,1,50),1:3});
% G     = griddedInterpolant({linspace(-1,1,u),linspace(0,1,v),1:3},Y,'spline','nearest');
% W     = G({linspace(-1,1,u),linspace(0,1,50),1:3});
% [P,T,W] = grid2mesh(P,W);
% G     = griddedInterpolant({linspace(-1,1,u),linspace(0,1,v),1:3},X,'spline','nearest'); 
end



function [Q,U,W] = point2curve(P, N, C, varargin)
[A,B] = C.segment();
t     = C.parameter();
t     = [t(1:end-1) t(2:end)];
dA    = point_plane_distance(P, N, A);
dB    = point_plane_distance(P, N, B);
i     = find((dA .* dB) <= 0);
[Q,a] = project_point_on_segment(A(i,:), B(i,:), P);
j     = min_index(distance(Q, P, 2));
x     = (1-a(j)) * t(i(j),1) + a(j) * t(i(j),2);
[Q,U,W]   = C.fetchData({'Point','Normal','Weight'}, x, varargin{:});
Q     = project_point_on_plane(P, N, Q);
end