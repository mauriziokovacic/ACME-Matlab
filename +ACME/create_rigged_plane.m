function [P, N, UV, T, Q, W, F, D] = create_rigged_plane( res, side, pad )
w = @(t) [t(:), (1-t(:))];
if( ( nargin < 3 ) || ( pad  <  0 ) || ( (2*pad) > (res^2) ) ) pad  = 0; end
if( ( nargin < 2 ) || ( side <= 0 ) ) side = 1; end
[P,N,UV,T,Q] = create_plane( res, side );
res = res + 1;
W = w(reshape(repmat([zeros(1,pad) linspace(0,1,res-2*pad) ones(1,pad)],res,1),res^2,1));
% W = w(reshape(repmat([zeros(1,pad) abs(sin(linspace(0,res/2*pi,res-2*pad))) ones(1,pad)],res,1),res^2,1));

% TR = triangulation([1 3 4; 4 2 1],...
%     [reshape(repmat(linspace(-side/2,side/2,2) ,2,1),4,1),...
%      reshape(repmat(linspace(-side/2,side/2,2)',2,1),4,1),...
%      zeros(4,1)]);
% Z = zeros(size(P,1),1);
% B1 = cartesianToBarycentric(TR,ones(size(P,1),1),P);
% B2 = cartesianToBarycentric(TR,ones(size(P,1),1)*2,P);
% [r1n c1] = find(B1<0);
% [r2n c2] = find(B2<0);
% r1 = setdiff(1:size(B1,1),r1n);
% r2 = setdiff(1:size(B2,1),r2n);
% W = zeros( size(P,1), 4 );
% W(r1n,:) = [B2(r1n,3) B2(r1n,2) Z(r1n)    B2(r1n,1)];
% W(r2 ,:) = [B2(r2 ,3) B2(r2 ,2) Z(r2)     B2(r2 ,1)];
% W(r2n,:) = [B1(r2n,1) Z(r2n)    B1(r2n,2) B1(r2n,3)];
% W(r1,:)  = [B1(r1 ,1) Z(r1)     B1(r1 ,2) B1(r1 ,3)];

F = fold_field(W);
D = fold_density(W);
end