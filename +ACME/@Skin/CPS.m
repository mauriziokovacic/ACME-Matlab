function [P ,N, varargout ] = CPS(obj,Pose,Op,varargin)
[P , N ] = obj.LBS(Pose);
if( nargout >= 5 )
    varargout{3} = P;
end
if( nargout >= 6 )
    varargout{4} = N;
end
[P_, N_] = Linear_Blend_Skinning( obj.P_ , obj.N_ , obj.W_, Pose);
% T  = compute_transform(Pose,obj.W_);
% P_ = transform_point(T,obj.P_,'mat');
% T_ = transform_normal(T,varargin{1},'mat');
% B_ = transform_normal(T,varargin{2},'mat');
% N_ = normr(cross(T_,B_,2));

D  = point_plane_distance( obj.P_, obj.N_, obj.M.P );
DD = point_plane_distance( P_    , N_    , P       );

A  = dot( obj.M.N, obj.N_, 2 );
AA = dot( N      ,     N_, 2 );

fD = function_distance( D, DD );
fA = function_angle( A, AA );
[alpha] = Op.fetch(fD,obj.I);

% beta = abs(beta);
% beta = (beta)./sum(beta,2);
% beta(~isfinite(beta)) = 0;

n = abs(DD-D) .* ( (1-fA) .* N + fA .* -N_ );
% p = P;
% P = P + obj.I .* alpha .* abs(DD-D) .* ( (1-fA)            .* N + fA              .* -N_ );
P = P + alpha .* n;
% N = N + -fA .* ( (1-fD) .* n + (fD) .* N_ );
N = N + fA .* alpha .* ( n + -N_);  % correct


% hold on;
% quiv3(P,normr(N),'Color','g');
% hold on;
% % quiv3(P,normr(n),'Color','b');
% hold on;
% % quiv3(P,normr(p-P),'Color','c');
% hold on;
% quiv3(P,-N_,'Color','y');


% N = normr(N);

DD = point_plane_distance( P_, N_, P );
i  = find( ( DD < 0 ) & ( D > 0.001 ) );
% j  = setdiff((1:size(P,1))',i);
% P(j,:) = P(j,:) + (DD(j,:)-D(j,:)) .* -( (1-F(j,1)) .* N(j,:) - (F(j,1)) .* N_(j,:));
% 
P(i,:) = P(i,:) - obj.I(i) .* DD(i,:) .* N_(i,:);
% N(i,:) = N(i,:) + ( beta(i,1) .* N(i,:) + ( clamp(fD(i) .* 2, 0, 1) ) .* beta(i,2) .* N_(i,:) );
N(i,:) = (obj.I(i)) .* N(i,:) + (1-obj.I(i)) .* -N_(i,:);
% % N(k,:) = normr(N(k,:));

N = normr(N);

if( nargout >= 3 )
    varargout{1} = P_;
end
if( nargout >= 4 )
    varargout{2} = N_;
end

if( nargout >= 5 )
    varargout{3} = fD;
end
if( nargout >= 6 )
    varargout{4} = fA;
end
if( nargout >= 7 )
    varargout{5} = alpha;
end

end